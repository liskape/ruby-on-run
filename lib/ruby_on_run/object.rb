class RubyOnRun::RObject

  attr_accessor :klass, :allow_private

  def initialize(klass)
    @klass = klass
    @allow_private = false
    @instance_variables = {}
  end

  def set_instance_variable(name, value)
    @instance_variables[name] = value
  end

  def get_instance_variable(name)
    @instance_variables[name]
  end

  
  @flags        # for GC
  @class
  @method_table # - implementation of metaclasses
                # (method lookup: serach in object, serch in class, and go up)

end
