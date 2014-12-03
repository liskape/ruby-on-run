require_relative './builtin'

module RubyOnRun::Builtin
  class RRange < Range
    
    include RubyOnRun::Builtin::Builtin
    extend RubyOnRun::Builtin::Builtin

  end
end
