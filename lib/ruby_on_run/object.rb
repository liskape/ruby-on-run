class RubyOnRun::RObject

  attr_accessor :klass, :allow_private

  def initialize(klass)
    @klass = klass
    @allow_private = false
    @instance_variables = {}
    @singleton_methods = {}
  end

  def set_instance_variable(name, value)
    @instance_variables[name] = value
  end

  def get_instance_variable(name)
    @instance_variables[name]
  end

  def add_singleton_method(name, code)
    @singleton_methods[name] = code
  end

  def get_singleton_method(name)
    @singleton_methods[name]
  end
  
  @flags        # for GC
  @class
  @method_table # - implementation of metaclasses
                # (method lookup: serach in object, serch in class, and go up)

end
