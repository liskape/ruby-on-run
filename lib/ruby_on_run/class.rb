# require 'object'
class RubyOnRun::RClass #< RubyOnRun::Object

  @superclass     # inheritance
  @constant_table # constants
  @vm             # needs for initialize

  def initialize(vm)
    @vm = vm
    @method_table = {}
  end

  def new(*args)
    _allocate(self, *args)
  end

  def define_method(name, code)
    @method_table[name] = code
  end

  def method(name)
    @method_table[name]
  end

  def method_visibility
  end

  # def send(message, *args)

    #@method_table.each { |x| interpret if x.name == message }
  # end

  private

  def _allocate(klass, *args)
    obj = RubyOnRun::RObject.new(klass)
    context = RubyOnRun::Context.new(klass.method(:initialize), klass, obj)
    context.add_binding create_binding(klass.method(:initialize).local_names, args)
    @vm.interpret context  # PARENT!!!
    obj
  end

  def create_binding(keys, values)
    Hash[keys.zip(values)]
  end

end
