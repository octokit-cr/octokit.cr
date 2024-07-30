module OpenSSL::X509
  class Extension
    def self.new(ctx : ExtensionFactory, oid : String, value : String, critical = false)
      raise Error.new("Invalid X509V3_CTX") unless ctx

      nid = LibCrypto.obj_ln2nid(oid)
      nid = LibCrypto.obj_sn2nid(oid) if nid == LibCrypto::NID_undef
      raise Error.new("OBJ_sn2nid") if nid == LibCrypto::NID_undef

      new(ctx, nid, value, critical)
    end

    def initialize(ctx : ExtensionFactory, nid : Int32, value : String, critical = false)
      valstr = String.build do |str|
        str << "critical," if critical
        str << value
      end
      @ext = LibCrypto.x509v3_ext_conf_nid(nil, ctx, nid, valstr)
      raise Error.new("X509V3_EXT_nconf_nid") if @ext.null?
    end
  end
end
