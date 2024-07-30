require "../bio/*"

module OpenSSL::PKey
  def self.read(encoded : String, passphrase = nil)
    self.read(IO::Memory.new(encoded), passphrase)
  end

  def self.read(io : IO, passphrase = nil)
    content = Bytes.new(io.size)
    io.read_fully(content)
    io.rewind

    cb, cb_u = OpenSSL::PKey.passphrase_callback(passphrase)

    bio = GETS_BIO.new(io)
    pkey = LibCrypto.pem_read_bio_private_key(bio, nil, cb, cb_u)
    io.rewind

    if pkey.null?
      begin
        decoded = Base64.decode(content)
        buf = IO::Memory.new(decoded)

        bio = GETS_BIO.new(buf)
        pkey = LibCrypto.d2i_private_key_bio(bio, nil)
        buf.rewind
      rescue Base64::Error
      end
    end

    if pkey.null?
      bio = GETS_BIO.new(io)
      pkey = LibCrypto.pem_read_bio_public_key(bio, nil, cb, cb_u)
      io.rewind
    end

    raise PKeyError.new if pkey.null?

    id = self.get_pkey_id(pkey)

    case id
    when LibCrypto::EVP_PKEY_RSA
      RSA.new io.dup
    when LibCrypto::EVP_PKEY_EC
      EC.new io.dup
    else
      ret = uninitialized PKey
      ret
    end
  end

  def self.get_pkey_id(pkey : LibCrypto::EvpPKey*) : Int32
    LibCrypto.evp_pkey_id(pkey)
  end

  def self.check_public_key(pkey : PKey)
    raise PKeyError.new("pkey missing") unless pkey

    case self.get_pkey_id(pkey.to_unsafe)
    when LibCrypto::EVP_PKEY_RSA
      rsa = LibCrypto.evp_pkey_get0_rsa(pkey)

      n = OpenSSL::BN.new
      e = OpenSSL::BN.new

      n_ptr = n.to_unsafe
      e_ptr = e.to_unsafe

      LibCrypto.rsa_get0_key(rsa, pointerof(n_ptr), pointerof(e_ptr), nil)

      unless n_ptr.null? || e_ptr.null?
        return true
      end
    when LibCrypto::EVP_PKEY_EC
      ec = LibCrypto.evp_pkey_get0_ec_key(pkey)
      ec_ptr = LibCrypto.ec_key_get0_public_key(ec)
      unless ec_ptr.null?
        return true
      end
    else
      return false
    end
    raise PKeyError.new "public key missing"
  end

  class PKeyError < OpenSSL::Error; end

  abstract class PKey
    def initialize(@pkey : LibCrypto::EvpPKey*, @is_private : Bool)
      raise PKeyError.new "Invalid EVP_PKEY" if @pkey.null?
    end

    def initialize(is_private : Bool)
      initialize(LibCrypto.evp_pkey_new, is_private)
    end

    def self.new(encoded : String, passphrase = nil, is_private = true)
      is_private = false if encoded.includes?("PUBLIC KEY-----")
      self.new(IO::Memory.new(encoded), passphrase, is_private)
    end

    def self.new(io : IO, passphrase = nil, is_private = true)
      cb, cb_u = OpenSSL::PKey.passphrase_callback(passphrase)
      if is_private
        begin
          bio = GETS_BIO.new(io.dup)
          new(LibCrypto.pem_read_bio_private_key(bio, nil, cb, cb_u), is_private)
        rescue
          bio = GETS_BIO.new(IO::Memory.new(Base64.decode(io.to_s)))
          new(LibCrypto.d2i_private_key_bio(bio, nil), is_private)
        end
      else
        bio = GETS_BIO.new(io.dup)
        new(LibCrypto.pem_read_bio_public_key(bio, nil, cb, cb_u), is_private)
      end
    end

    def to_unsafe
      @pkey
    end

    def finalize
      LibCrypto.evp_pkey_free(self)
    end

    def private?
      @is_private
    end

    def public?
      !private?
    end

    def to_pem(io : IO, cipher : (OpenSSL::Cipher | Nil) = nil, passphrase = nil)
      bio = BIO.new(io)

      if private?
        cipher_pointer = nil

        if !cipher.nil?
          unsafe = cipher.to_unsafe
          cipher_pointer = pointerof(unsafe)
        end

        cb, cb_u = OpenSSL::PKey.passphrase_callback(passphrase)
        raise PKeyError.new "Could not write to PEM" unless LibCrypto.pem_write_bio_pkcs8_private_key(bio, self, cipher_pointer, nil, 0, cb, cb_u) == 1
      else
        raise PKeyError.new "Could not write to PEM" unless LibCrypto.pem_write_bio_public_key(bio, self) == 1
      end
    end

    def to_pem(cipher : OpenSSL::Cipher, passphrase)
      io = IO::Memory.new
      to_pem(io, cipher, passphrase)
      io.to_s
    end

    def to_pem
      io = IO::Memory.new
      to_pem(io)
      io.to_s
    end

    def to_der
      io = IO::Memory.new
      to_der(io)
      Base64.encode(io.to_s)
    end

    def to_der(io)
      fn = ->(buf : UInt8**) {
        if private?
          LibCrypto.i2d_private_key(self, buf)
        else
          LibCrypto.i2d_public_key(self, buf)
        end
      }

      len = fn.call(Pointer(Pointer(UInt8)).null)
      if len <= 0
        raise PKeyError.new "Could not output in DER format"
      end
      slice = Slice(UInt8).new(len)
      p = slice.to_unsafe
      len = fn.call(pointerof(p))

      output = slice[0, len]
      io.write(output)
    end

    def sign(digest, data)
      unless private?
        raise PKeyError.new "Private key is needed"
      end

      slice = Slice(UInt8).new(max_encrypt_size)
      digest.update(data)

      # don't think this is required
      # digest_pointer = digest.to_unsafe

      raise PKeyError.new "Unable to sign" unless LibCrypto.evp_sign_final(digest, slice, out len, self)

      slice[0, len.to_i32]
    end

    def verify(digest, signature, data)
      signature = signature.to_slice
      digest.update(data)

      case LibCrypto.evp_verify_final(digest, signature, signature.size.to_u32, self)
      when 0
        false
      when 1
        true
      else
        raise PKeyError.new "Unable to verify"
      end
    end

    private def max_encrypt_size
      LibCrypto.evp_pkey_size(self)
    end
  end

  protected def self.passphrase_callback(passphrase) : {LibCrypto::PasswordCallback, Void*}
    if passphrase
      cb = ->(buffer : UInt8*, key_size : Int32, _is_read_write : Int32, u : Void*) {
        pwd = Box(Bytes).unbox(u)

        if pwd.size > key_size
          raise PKeyError.new "Passphrase longer than PEM_BUFSIZE (#{key_size})", fetched: true
        end

        pwd.copy_to(buffer, pwd.size)

        pwd.size
      }
      cb_u = Box.box(passphrase.to_slice)
    else
      cb = LibCrypto::PasswordCallback.new(Pointer(Void).null, Pointer(Void).null)
      cb_u = Pointer(Void).null
    end

    {cb, cb_u}
  end
end
