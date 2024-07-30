require "./x509"

module OpenSSL::X509
  class CertificateError < X509Error; end

  class Certificate
    def initialize
      previous_def

      self.version = 2
      self.serial = OpenSSL::BN.rand
    end

    def self.new(pem : String)
      io = IO::Memory.new(pem)
      bio = OpenSSL::GETS_BIO.new(io)
      x509 = LibCrypto.pem_read_bio_x509(bio, nil, nil, nil)

      raise CertificateError.new "Could not read PEM" unless x509
      new x509
    end

    def self.from_pem(pem : String)
      self.new(pem)
    end

    def self.from_pem(io : IO)
      self.new(io.gets_to_end)
    end

    def version
      LibCrypto.x509_get_version(self)
    end

    def version=(n : Int32)
      LibCrypto.x509_set_version(self, 2_i64)
    end

    def serial : OpenSSL::BN
      sn = LibCrypto.x509_get_serialnumber(self)
      OpenSSL::BN.new LibCrypto.asn1_integer_to_bn(sn)
    end

    def serial=(index : UInt64)
      bn = OpenSSL::BN.new(index)
      self.serial = bn
    end

    def serial=(bn : OpenSSL::BN)
      sn = LibCrypto.bn_to_asn1_integer(bn, nil)
      LibCrypto.x509_set_serialnumber(self, sn)
    end

    def issuer
      issuer = LibCrypto.x509_get_issuer_name(self)
      raise CertificateError.new "Can not get issuer" unless issuer

      Name.new(issuer)
    end

    def issuer=(subject : Name)
      LibCrypto.x509_set_issuer_name(self, subject)
    end

    def public_key
      io = IO::Memory.new
      bio = OpenSSL::GETS_BIO.new(io)

      begin
        pkey = LibCrypto.x509_get_public_key(self)

        LibCrypto.pem_write_bio_public_key(bio, pkey)
        io.rewind

        case OpenSSL::PKey.get_pkey_id(pkey)
        when LibCrypto::EVP_PKEY_RSA
          OpenSSL::PKey::RSA.new io.dup
        when LibCrypto::EVP_PKEY_EC
          OpenSSL::PKey::EC.new io.dup
        else
          ret = uninitialized OpenSSL::PKey::PKey
          ret
        end
      rescue
        raise CertificateError.new "X509_get_pubkey"
      end
    end

    def public_key=(pkey)
      LibCrypto.x509_set_public_key(self, pkey)
    end

    def not_before=(time : ASN1::Time)
      LibCrypto.x509_set_notbefore(self, time)
    end

    def not_after=(time : ASN1::Time)
      LibCrypto.x509_set_notafter(self, time)
    end

    def sign(pkey : OpenSSL::PKey::PKey, digest : Digest)
      if LibCrypto.x509_sign(self, pkey.to_unsafe, digest.to_unsafe_md) == 0
        raise CertificateError.new("X509_sign")
      end
    end

    def verify(pkey : OpenSSL::PKey::PKey)
      return false unless OpenSSL::PKey.check_public_key(pkey)

      case LibCrypto.x509_verify(self, pkey)
      when 1
        true
      when 0
        false
      else
        raise CertificateError.new
      end
    end

    def to_pem(io)
      bio = OpenSSL::GETS_BIO.new(io)
      raise CertificateError.new "Could not convert to PEM" unless LibCrypto.pem_write_bio_x509(bio, self)
    end

    def to_pem
      io = IO::Memory.new
      to_pem(io)
      io.to_s
    end

    def to_unsafe_pointer
      pointerof(@cert)
    end
  end
end
