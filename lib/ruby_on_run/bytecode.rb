# https://github.com/rubinius/rubinius-compiler/blob/2.0/lib/rubinius/compiler/compiled_file.rb
require 'ostruct'

class RubyOnRun::Bytecode < Struct.new(:magic, :signature, :version, :stream)

  CompiledCode        = Class.new OpenStruct
  InstructionSequence = Class.new Array
  Tuple               = Class.new Array


  ##
  # From a stream-like object +stream+ load the data in and return a
  # CompiledFile object.
  def self.load(stream)
    new stream.lines[0].chomp,
        Integer(stream.lines[1].chomp),
        Integer(stream.lines[2].chomp),
        stream.lines[3..-1].join
  end

  ##
  # Return the body object by unmarshaling the data
  def body
    @data ||= BytecodeParser.new(stream).parse
  end

  ##
  # A class used to convert an stream to compiled code
  class BytecodeParser

    def initialize(stream)
      @start = 0
      @size = stream.size
      @data = stream.bytes
    end

    def parse
      unmarshal_data
    end

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
        obj = Tuple.new(count)
        i = 0
        while i < count
          obj[i] = unmarshal_data
          i += 1
        end
        return obj
      when 105 # ?i
        count = next_string.to_i
        seq = InstructionSequence.new(count)
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
        code = CompiledCode.new
        code.metadata = unmarshal_data
        code.primitive = unmarshal_data
        code.name = unmarshal_data
        code.iseq = unmarshal_data
        code.stack_size = unmarshal_data
        code.local_count = unmarshal_data
        code.required_args = unmarshal_data
        code.post_args = unmarshal_data
        code.total_args = unmarshal_data
        code.splat = unmarshal_data
        code.keywords = unmarshal_data
        code.arity = unmarshal_data
        code.literals = unmarshal_data
        code.lines = unmarshal_data
        code.file = unmarshal_data
        code.local_names = unmarshal_data
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
      str = @data.slice(@start, count).map(&:chr).join
      @start += count + 1
      str
    end
  end
end
