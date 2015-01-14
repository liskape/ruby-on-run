require_relative './builtin'

module RubyOnRun::Builtin
  class RFile < File
    
    include RubyOnRun::Builtin::Builtin
    extend RubyOnRun::Builtin::Builtin

  end
end
