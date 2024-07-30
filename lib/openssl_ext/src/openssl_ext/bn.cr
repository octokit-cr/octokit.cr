require "big"

module OpenSSL
  class BNError < Error; end

  class BN
    # include Comparable(BN)

    BN_RAND_TOP_ANY    = -1
    BN_RAND_TOP_ONE    =  0
    BN_RAND_TOP_TWO    =  1
    BN_RAND_BOTTOM_ANY =  0
    BN_RAND_BOTTOM_ODD =  1

    def initialize(@bn : LibCrypto::Bignum*)
      raise BNError.new if @bn.null?
    end

    def self.new
      new(LibCrypto.bn_new)
    end

    def self.new(num : UInt64)
      new.tap do |bn|
        LibCrypto.bn_set_word(bn.to_unsafe, num)
      end
    end

    def self.zero
      self.new(0)
    end

    def self.one
      self.new(1)
    end

    def self.rand
      new.tap do |bn|
        LibCrypto.bn_rand(bn, 128, BN_RAND_TOP_ANY, BN_RAND_BOTTOM_ANY)
      end
    end

    def self.new(integer : Int)
      from_dec(integer.to_s)
    end

    def self.from_dec(integer : String)
      new.tap do |bn|
        unsafe = bn.to_unsafe
        LibCrypto.bn_from_dec(pointerof(unsafe), integer)
      end
    end

    def self.from_hex(integer : String)
      new.tap do |bn|
        unsafe = bn.to_unsafe
        LibCrypto.bn_from_hex(pointerof(unsafe), integer)
      end
    end

    def self.from_bin(integer : Bytes)
      new.tap do |bn|
        unsafe = bn.to_unsafe
        LibCrypto.bn_from_bin(integer, integer.size, unsafe)
      end
    end

    def finalize
      LibCrypto.bn_free(self)
    end

    def print
      bio = OpenSSL::MemBIO.new
      LibCrypto.bn_print(bio, self)
      bio.to_string
    end

    def size
      (LibCrypto.bn_num_bits(self) + 7) // 8
    end

    def to_bin
      to = Bytes.new size
      LibCrypto.bn_to_bin(self, to)
      to
    end

    def to_dec
      String.new LibCrypto.bn_to_dec(self)
    end

    def to_hex
      String.new LibCrypto.bn_to_hex(self)
    end

    def to_mpi
      to = Bytes.new size
      LibCrypto.bn_to_mpi(self, to)
      to
    end

    def to_big_i
      BigInt.new(to_hex, 16)
    end

    def to_big
      to_big_i
    end

    def to_unsafe
      @bn
    end
  end
end
