require_relative './builtin'

class NilClass
  include RubyOnRun::Builtin::Builtin
end
