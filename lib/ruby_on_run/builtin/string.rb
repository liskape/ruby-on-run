require_relative './builtin'

class String
  include RubyOnRun::Builtin::Builtin
end
