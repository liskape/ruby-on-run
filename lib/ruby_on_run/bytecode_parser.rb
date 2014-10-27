class RubyOnRun::BytecodeParser
  ##
  # Create a CompiledFile with +magic+ bytes, +signature+, and +version+.
  # The optional +stream+ is used to lazy load the body.

  def initialize(magic, signature, version, stream=nil)
    @magic = magic
    @signature = signature
    @version = version
    @stream = stream
    @data = nil
  end

  attr_reader :magic
  attr_reader :signature
  attr_reader :version
  attr_reader :stream

  ##
  # From a stream-like object +stream+ load the data in and return a
  # CompiledFile object.
  def self.load(stream)
    raise IOError, "attempted to load nil stream" unless stream

    magic = stream.lines[0].chomp
    signature = Integer(stream.lines[1].chomp)
    version = Integer(stream.lines[2].chomp)

    return new(magic, signature, version, stream.lines[3..-1].join)
  end

  ##
  # Return the body object by unmarshaling the data
  def body
    return @data if @data

    @data = Marshal.new.unmarshal(stream)
  end

  ##
  # A class used to convert an CompiledCode to and from
  # a String.
  class Marshal

    ##
    # Read all data from +stream+ and invoke unmarshal_data
    def unmarshal(stream)
      if stream.kind_of? String
        str = stream
      else
        str = stream.read
      end

      @start = 0
      @size = str.size
      @data = str.bytes

      unmarshal_data
    end

    ##
    # Process a stream object +stream+ as as marshalled data and
    # return an object representation of it.
    def unmarshal_data
      kind = next_type
      case kind
      when 116 # ?t
        return true
      when 102 # ?f
        return false
      when 110 # ?n
        return nil
      when 73  # ?I
        return next_string.to_i(16)
      when 100 # ?d
        str = next_string.chop

        # handle the special NaN, Infinity and -Infinity differently
        if str[0] == ?\     # leading space
          x = str.to_f
          e = str[-5..-1].to_i

          # This is necessary because (2**1024).to_f yields Infinity
          if e == 1024
            return x * 2 ** 512 * 2 ** 512
          else
            return x * 2 ** e
          end
        else
          case str.downcase
          when "infinity"
            return 1.0 / 0.0
          when "-infinity"
            return -1.0 / 0.0
          when "nan"
            return 0.0 / 0.0
          else
            raise TypeError, "Invalid Float format: #{str}"
          end
        end
      when 115 # ?s
        enc = unmarshal_data
        count = next_string.to_i
        str = next_bytes count
        str.force_encoding enc if enc
        return str
      when 120 # ?x
        enc = unmarshal_data
        count = next_string.to_i
        str = next_bytes count
        str.force_encoding enc if enc
        return str.to_sym
      when 99  # ?c
        count = next_string.to_i
        str = next_bytes count
        return str.split("::").inject(Object) { |a,n| a.const_get(n) }
      when 112 # ?p
        count = next_string.to_i
        obj = Rubinius::Tuple.new(count)
        i = 0
        while i < count
          obj[i] = unmarshal_data
          i += 1
        end
        return obj
      when 105 # ?i
        count = next_string.to_i
        seq = Rubinius::InstructionSequence.new(count)
        i = 0
        while i < count
          seq[i] = next_string.to_i
          i += 1
        end
        return seq
      when 69  # ?E
        count = next_string.to_i
        name = next_bytes count
        return Encoding.find(name)
      when 77  # ?M
        version = next_string.to_i
        if version != 1
          raise "Unknown CompiledCode version #{version}"
        end
        code = Rubinius::CompiledCode.new
        code.metadata      = unmarshal_data
        code.primitive     = unmarshal_data
        code.name          = unmarshal_data
        code.iseq          = unmarshal_data
        code.stack_size    = unmarshal_data
        code.local_count   = unmarshal_data
        code.required_args = unmarshal_data
        code.post_args     = unmarshal_data
        code.total_args    = unmarshal_data
        code.splat         = unmarshal_data
        code.literals      = unmarshal_data
        code.lines         = unmarshal_data
        code.file          = unmarshal_data
        code.local_names   = unmarshal_data
        return code
      else
        raise "Unknown type '#{kind.chr}'"
      end
    end


    ##
    # Returns the next character in _@data_ as a Fixnum.
    #--
    # The current format uses a one-character type indicator
    # followed by a newline. If that format changes, this
    # will break and we'll fix it.
    #++
    def next_type
      chr = @data[@start]
      @start += 2
      chr
    end

    ##
    # Returns the next string in _@data_ including the trailing
    # "\n" character.
    def next_string
      count = @data[@start..-1].index("\n".bytes.first) + 1
      count = @size unless count
      str = @data.slice(@start, count).map(&:chr).join
      @start += count
      str
    end

    ##
    # Returns the next _count_ bytes in _@data_, skipping the
    # trailing "\n" character.
    def next_bytes(count)
      str = String.from_bytearray @data, @start, count
      @start += count + 1
      str
    end

    ##
    # A helper function to force strings to ASCII-8BIT encoding. This is
    # needed because Ruby's encoding system causes the result of a UTF-8
    # string interpolated in a file (like this one) with a ASCII-8BIT
    # encoding magic comment to be UTF-8. In other words, given the
    # following script:
    #
    #   # -*- encoding: ascii-8bit -*s
    #
    #   x = "❤"
    #   s = "abc #{x}"
    #
    # the string, s, will have UTF-8 encoding, NOT ASCII-8BIT encoding.
    def b(val)
      val.force_encoding Encoding::ASCII_8BIT
    end
  end
end


#TODO methods
# locate @data[@start..-1].index("\n".bytes.first) + @start
