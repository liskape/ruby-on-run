# class representing a frame in VMStack
class VMStackFrame

  attr_accessor :literals, :bytecode_pointer, :parent, :locals

  @method
  @bytecode
  @args  
  @stack

  def initialize()
    @stack = []
	@literals = []
	@bytecode_pointer = 0
	@locals = Hash.new
  end  
  
  def push(x)
    @stack.push(x)
  end
  
  def pop
    @stack.pop
  end
  
  def top
    top = @stack.pop
    @stack.push(top)
    top
  end
  
end
