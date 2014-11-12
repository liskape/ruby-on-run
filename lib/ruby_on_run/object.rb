class RubyOnRun::RObject < BasicObject

  attr_accessor :class

  def initialize(klass)
    @class = klass
  end

  @instance_variables = {}
  @flags        # for GC
  @class
  @method_table # - implementation of metaclasses
                # (method lookup: serach in object, serch in class, and go up)

end
