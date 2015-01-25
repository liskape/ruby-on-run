require_relative './builtin'

class Bignum
  include RubyOnRun::Builtin::Builtin
end
