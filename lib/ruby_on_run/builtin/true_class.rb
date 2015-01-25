require_relative './builtin'

class TrueClass
  include RubyOnRun::Builtin::Builtin
end
