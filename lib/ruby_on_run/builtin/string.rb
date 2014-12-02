require_relative './builtin'

module RubyOnRun::Builtin
  class RString < String
    
    include RubyOnRun::Builtin::Builtin

    def +(other)
      RString.new super(other)
    end

    def allocate    
    end
  end
end
