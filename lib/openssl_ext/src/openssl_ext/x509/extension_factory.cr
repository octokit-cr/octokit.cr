module OpenSSL::X509
  class ExtensionFactory
    def initialize(@ctx : LibCrypto::X509V3_CTX)
      raise Error.new "Invalid X509V3_CTX" unless @ctx

      LibCrypto.x509v3_set_ctx(pointerof(@ctx), nil, nil, nil, nil, 0)
    end

    def self.new
      new(LibCrypto::X509V3_CTX.new)
    end

    def create_extension(oid : String, value : String, critical = false) : Extension
      Extension.new(self, oid, value, critical)
    end

    def subject_certificate=(subject : Certificate)
      @ctx.subject_cert = subject.to_unsafe.as Pointer(Void)
    end

    def issuer_certificate=(issuer : Certificate)
      @ctx.issuer_cert = issuer.to_unsafe.as Pointer(Void)
    end

    def to_unsafe
      pointerof(@ctx)
    end
  end
end
