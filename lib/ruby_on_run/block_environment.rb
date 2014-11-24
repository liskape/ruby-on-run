class RubyOnRun::BlockEnvironment

  attr_accessor :code

  def initialize(code, vm)
    @compiled_code = code
    @vm = vm
  end

  def call_under(klass, scope, dummy)
    # zacit vykonavat @compiled_code.iseq
    # binding.pry
    context = RubyOnRun::Context.new(@compiled_code, klass, klass)
    @vm.interpret context
  end

end
