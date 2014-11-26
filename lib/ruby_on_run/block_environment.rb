class RubyOnRun::BlockEnvironment

  attr_accessor :code

  def initialize(code, parent_context, vm)
    @compiled_code = code
    @parent_context = parent_context
    @vm = vm
  end

  def call_under(klass, scope, dummy)
    # zacit vykonavat @compiled_code.iseq
    # binding.pry
    context = RubyOnRun::Context.new(@compiled_code, klass, klass, @parent_context)
    @vm.interpret context
  end

end
