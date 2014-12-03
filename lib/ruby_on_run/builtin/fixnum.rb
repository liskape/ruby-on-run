require_relative './builtin'

class Fixnum
  include RubyOnRun::Builtin::Builtin
end
