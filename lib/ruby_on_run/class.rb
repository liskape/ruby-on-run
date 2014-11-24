# require 'object'
class RubyOnRun::RClass #< RubyOnRun::Object

  @method_table
  @alocator       # 
  @superclass     # inheritance
  @constant_table # constants

  def initialize
    @alocator = BasicAllocator.new
    @method_table = []
  end

  def new(*args)
    @alocator.allocate(self, *args)
  end

  def define_method
  end
  
  def send(message, *args)
    #@method_table.each { |x| interpret if x.name == message }
  end

end

class BasicAllocator

  def allocate(klass, *args)
    obj = RubyOnRun::RObject.new(klass)
    obj.initialize(args)
    obj
  end

end
