class RubyOnRun::RObject

  attr_accessor :class, :allow_private

  def initialize(klass)
    @class = klass
    @allow_private = false
  end



  @instance_variables = {}
  @flags        # for GC
  @class
  @method_table # - implementation of metaclasses
                # (method lookup: serach in object, serch in class, and go up)

end
