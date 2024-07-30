require "../bio/mem_bio"
require "./pkey"

module OpenSSL::PKey
  class EcError < PKeyError; end

  class EC < PKey
    def self.new(key : String)
      self.new(IO::Memory.new(key))
    end

    def self.new(io : IO)
      content = Bytes.new(io.size)
      io.read(content)

      priv = true

      bio = GETS_BIO.new(IO::Memory.new(content))
      ec_key = LibCrypto.pem_read_bio_ecprivatekey(bio, nil, nil, nil)
      io.rewind

      if ec_key.null?
        begin
          decoded = Base64.decode(content)
          buf = IO::Memory.new(decoded)

          bio = GETS_BIO.new(buf)
          ec_key = LibCrypto.d2i_ecprivatekey_bio(bio, nil)
        rescue Base64::Error
        end
      end

      if ec_key.null?
        bio = GETS_BIO.new(io)
        ec_key = LibCrypto.pem_read_bio_ec_pubkey(bio, nil, nil, nil)
        priv = false unless ec_key.null?
        io.rewind
      end

      if ec_key.null?
        raise EcError.new "Neither PUB or PRIV key"
      end

      new(priv).tap do |pkey|
        LibCrypto.evp_pkey_assign(pkey, LibCrypto::EVP_PKEY_EC, ec_key.as Pointer(Void))
      end
    end

    def self.new(size : Int32)
      generate(size)
    end

    def self.generate(size : Int32)
      nist_name = "P-#{size}"
      nid = LibCrypto.ec_curve_nist2nid(nist_name)

      if nid.zero?
        raise EcError.new "Can not find your specific key size"
      end

      generate(nist_name)
    end

    def self.generate(type : String)
      nid = LibCrypto.ec_curve_nist2nid(type)
      raise EcError.new("unknown NIST Curve: #{type}") if nid.zero?
      ec_key = LibCrypto.ec_key_new_by_curve_name(nid)
      LibCrypto.ec_key_set_asn1_flag(ec_key, LibCrypto::OPENSSL_EC_NAMED_CURVE)
      if LibCrypto.ec_key_generate_key(ec_key) == 0
        LibCrypto.ec_key_free(ec_key)
        raise EcError.new
      end

      new(true).tap do |pkey|
        LibCrypto.evp_pkey_assign(pkey, LibCrypto::EVP_PKEY_EC, ec_key.as Pointer(Void))
      end
    end

    def public_key
      f1 = ->LibCrypto.i2d_ec_pubkey
      f2 = ->LibCrypto.d2i_ec_pubkey

      pub_ec = LibCrypto.asn1_dup(f1.pointer, f2.pointer, ec.as(Void*))
      EC.new(false).tap do |pkey|
        LibCrypto.evp_pkey_assign(pkey, LibCrypto::EVP_PKEY_EC, pub_ec.as Pointer(Void))
      end
    end

    def to_pem(io)
      bio = GETS_BIO.new(io)
      if private?
        LibCrypto.pem_write_bio_ecprivatekey(bio, ec, nil, nil, 0, nil, nil)
      else
        LibCrypto.pem_write_bio_ec_pubkey(bio, ec)
      end
    end

    def to_text
      bio = MemBIO.new
      LibCrypto.ecdsa_print(bio, ec, 0)
      bio.to_string
    end

    def to_der(io)
      fn = ->(buf : UInt8**) {
        if private?
          LibCrypto.i2d_ecprivatekey(ec, buf)
        else
          LibCrypto.i2d_ec_pubkey(ec, buf)
        end
      }
      len = fn.call(Pointer(Pointer(UInt8)).null)
      if len <= 0
        raise EcError.new "Could not output in DER format"
      end
      slice = Slice(UInt8).new(len)
      p = slice.to_unsafe
      len = fn.call(pointerof(p))

      output = slice[0, len]
      io.write(output)
    end

    def ec_sign(data)
      unless private?
        raise EcError.new "need a private key"
      end
      data = data.to_slice
      to = Slice(UInt8).new max_encrypt_size
      if LibCrypto.ecdsa_sign(0, data, data.size, to, out len, ec) != 1
        raise EcError.new
      end
      to[0, len]
    end

    def ec_verify(digest, signature)
      digest = digest.to_slice
      signature = signature.to_slice
      res = LibCrypto.ecdsa_verify(0, digest, digest.size, signature, signature.size, ec)

      case res
      when 1
        true
      when 0
        false
      else
        raise EcError.new
      end
    end

    def group
      EC::Group.new self
    end

    def group_degree
      LibCrypto.ec_group_get_degree LibCrypto.ec_key_get0_group(ec)
    end

    private def ec
      LibCrypto.evp_pkey_get1_ec_key(self)
    end

    private def max_encrypt_size
      LibCrypto.ecdsa_size(ec)
    end
  end
end

require "./ec/*"
