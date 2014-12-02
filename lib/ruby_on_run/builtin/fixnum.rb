require_relative './builtin'

module RubyOnRun::Builtin
  class RFixnum
    
    include RubyOnRun::Builtin::Builtin

    def initialize(number)
      @number = number
    end

    def +(other)
      RFixnum.new(to_i + other.to_i)
    end

    def *(other)
      RFixnum.new(to_i * other.to_i)
    end


    def >(other)
      to_i > other.to_i
    end

    # def inspect
    #   @number.to_s
    # end

    def to_i
      @number
    end
  end
end
