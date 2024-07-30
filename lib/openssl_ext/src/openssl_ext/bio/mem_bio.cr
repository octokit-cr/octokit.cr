require "../bio"

class OpenSSL::MemBIO < IO
  def initialize(@bio : LibCrypto::Bio*)
    raise BioError.new "Invalid handle" unless @bio
  end

  def initialize
    initialize LibCrypto.bio_new(LibCrypto.bio_s_mem)
  end

  def read(slice : Bytes)
    LibCrypto.bio_read(self, slice, slice.size)
  end

  {% if compare_versions(Crystal::VERSION, "0.35.0") == 0 %}
    def write(slice : Bytes) : Int64
      LibCrypto.bio_write(self, slice, slice.size)
      slice.size.to_i64
    end
  {% else %}
    def write(slice : Bytes) : Nil
      LibCrypto.bio_write(self, slice, slice.size)
    end
  {% end %}

  def reset
    LibCrypto.bio_ctrl(self, LibCrypto::BIO_CTRL_RESET, 0_i64, nil)
  end

  def finalize
    LibCrypto.bio_free_all(self)
  end

  def to_string
    buf = IO::Memory.new
    IO.copy(self, buf)
    buf.to_s
  end

  def to_unsafe
    @bio
  end
end
