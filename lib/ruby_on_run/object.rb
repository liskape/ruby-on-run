class RubyOnRun::RObject

  attr_accessor :class, :allow_private

  def initialize(klass)
    @class = klass
    @allow_private = false
    @instance_variables = {}
  end

  def set_instance_variable(name, value)
    @instance_variables[name] = value
  end



  
  @flags        # for GC
  @class
  @method_table # - implementation of metaclasses
                # (method lookup: serach in object, serch in class, and go up)

end
