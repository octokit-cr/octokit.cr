require "big"

class OpenSSL::PKey::EC::Point
  def initialize(group : EC::Group, generator : Bool = false)
    @internal = generator
    if generator
      @point = LibCrypto.ec_group_get0_generator(group)
    else
      @point = LibCrypto.ec_point_new(group)
    end
    @group = group
  end

  def initialize(group : EC::Group, point : EC::Point)
    @internal = false
    @group = group
    @point = LibCrypto.ec_point_dup(point, group)
  end

  def self.new(group : EC::Group, bytes : Bytes)
    point = EC::Point.new(group)
    point.at_position(bytes)
  end

  @internal : Bool
  @point : Pointer(LibCrypto::EcPoint)
  getter group : EC::Group

  def to_unsafe
    @point
  end

  def finalize
    LibCrypto.ec_point_free(self) unless @internal
  end

  def dup
    self.class.new(group, self)
  end

  def mul(integer : Int) : EC::Point
    mul BN.new(integer)
  end

  def mul(integer : BN) : EC::Point
    result = EC::Point.new(group)
    success = LibCrypto.ec_point_mul(group, result, Pointer(LibCrypto::Bignum).null, self, integer, Pointer(Void).null)
    raise EcError.new("failed to multiply point") if success.zero?
    result
  end

  def add(point : EC::Point) : EC::Point
    result = EC::Point.new(group)
    success = LibCrypto.ec_point_add(group, result, self, point, Pointer(Void).null)
    raise EcError.new("failed to add point") if success.zero?
    result
  end

  def invert : EC::Point
    success = LibCrypto.ec_point_invert(group, self, Pointer(Void).null)
    raise EcError.new("failed to invert (negate) point") if success.zero?
    self
  end

  def negate
    invert
  end

  def uncompressed_bytes : Bytes
    length = LibCrypto.ec_point_point2oct(group, self, LibCrypto::PointConversionForm::UNCOMPRESSED, Pointer(LibC::Char).null, 0, Pointer(Void).null)
    raise EcError.new("failed to obtain uncompressed point length") if length.zero?
    bytes = Bytes.new(length)
    length = LibCrypto.ec_point_point2oct(group, self, LibCrypto::PointConversionForm::UNCOMPRESSED, bytes, length, Pointer(Void).null)
    raise EcError.new("failed to fill buffer with uncompressed point data") if length.zero?
    bytes
  end

  def to_slice
    uncompressed_bytes
  end

  def at_position(integer : Bytes)
    success = LibCrypto.ec_point_oct2point(group, self, integer, integer.size, Pointer(Void).null)
    raise EcError.new("failed to configure point position") if success.zero?
    self
  end

  def valid? : Bool
    success = LibCrypto.ec_point_is_on_curve(group, self, Pointer(Void).null)
    success == 1
  end
end
