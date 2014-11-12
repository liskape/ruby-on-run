class RubyOnRun::BlockEnvironment

  attr_accessor :code

  def initialize(code)
    @compiled_code = code
  end

  def call_under(dummy, scope, klass)
    raise "here define class methods!"
    # zacit vykonavat @compiled_code.iseq
    # binding.pry
    true
  end

end
