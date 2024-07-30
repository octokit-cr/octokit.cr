require "./point"
require "big"

class OpenSSL::PKey::EC::Group
  def initialize(ec : EC)
    @internal = true
    @group = LibCrypto.ec_key_get0_group(LibCrypto.evp_pkey_get1_ec_key(ec))
  end

  @internal : Bool
  @group : LibCrypto::EC_GROUP

  getter parameters : NamedTuple(prime_modulus: BN, coefficient_a: BN, coefficient_b: BN) do
    p = BN.new
    a = BN.new
    b = BN.new
    result = LibCrypto.ec_group_get_curve(self, p, a, b, Pointer(Void).null)
    raise EcError.new("failed to get parameters") if result.zero?
    {prime_modulus: p, coefficient_a: a, coefficient_b: b}
  end

  getter prime_modulus : BN do
    parameters[:prime_modulus]
  end

  getter coefficient_a : BN do
    parameters[:coefficient_a]
  end

  getter coefficient_b : BN do
    parameters[:coefficient_b]
  end

  def to_unsafe
    @group
  end

  def finalize
    LibCrypto.ec_group_free(self) unless @internal
  end

  def degree
    LibCrypto.ec_group_get_degree self
  end

  def baselen
    degree // 8
  end

  def generator : Point
    Point.new self, generator: true
  end

  def point : Point
    Point.new self
  end

  def point(integer : Bytes) : Point
    Point.new self, integer
  end

  def point(integer : BigInt) : Point
    point OpenSSL::BN.new(integer).to_bin
  end

  def order : BigInt
    bn = BN.new
    success = LibCrypto.ec_group_get_order(self, bn, Pointer(Void).null)
    raise EcError.new("failed to get order") if success.zero?
    bn.to_big
  end
end
