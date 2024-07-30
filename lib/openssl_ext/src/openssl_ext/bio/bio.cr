module OpenSSL
  class BioError < Error; end
end

class OpenSSL::GETS_BIO
  BIO_C_FILE_TELL = 133
  BIO_C_FILE_SEEK = 128

  GETS_BIO = begin
    crystal_bio = OpenSSL::BIO::CRYSTAL_BIO

    ctrl = LibCrypto::BioMethodCtrl.new do |bio, cmd, _num, _ptr|
      val = case cmd
            when LibCrypto::CTRL_FLUSH
              io = Box(IO).unbox(BIO.get_data(bio))
              io.flush
              1
            when LibCrypto::CTRL_PUSH, LibCrypto::CTRL_POP, LibCrypto::CTRL_EOF
              0
            when BIO_C_FILE_TELL, BIO_C_FILE_SEEK
              0
            when LibCrypto::CTRL_SET_KTLS_SEND
              0
            when LibCrypto::CTRL_GET_KTLS_SEND, LibCrypto::CTRL_GET_KTLS_RECV
              0
            else
              STDERR.puts "WARNING: Unsupported BIO ctrl call (#{cmd})"
              0
            end
      LibCrypto::Long.new(val)
    end

    bgets = LibCrypto::BioMethodGets.new do |bio, buffer, len|
      io = Box(IO).unbox(BIO.get_data(bio))
      io.flush

      position = io.pos

      line = io.gets(len, false)

      if line.nil?
        0
      else
        io.seek(position)
        bytes = io.read(Slice.new(buffer, line.bytesize)).to_i

        bytes -= 1 unless bytes == 1
        bytes
      end
    end
    # use our version of ctrl to avoid warnings
    # is also more performant than the standard library version
    {% if compare_versions(LibCrypto::OPENSSL_VERSION, "1.1.0") >= 0 %}
      LibCrypto.BIO_meth_set_ctrl(crystal_bio, ctrl)
      LibCrypto.BIO_meth_set_gets(crystal_bio, bgets)
    {% else %}
      crystal_bio.value.ctrl = ctrl
      crystal_bio.value.bgets = bgets
    {% end %}
    crystal_bio
  end

  @boxed_io : Void*

  def initialize(@io : IO)
    @bio = LibCrypto.BIO_new(GETS_BIO)

    # We need to store a reference to the box because it's
    # stored in `@bio.value.ptr`, but that lives in C-land,
    # not in Crystal-land.
    @boxed_io = Box(IO).box(io)

    BIO.set_data(@bio, @boxed_io)
  end

  def finalize
    LibCrypto.bio_free_all(@bio)
  end

  getter io

  def to_unsafe
    @bio
  end
end
