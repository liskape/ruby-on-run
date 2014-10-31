# class representing a frame in VMStack
class VMStackFrame

  @method
  @bytecode
  @bytecode_pointer
  @literals
  @args
  @locals
  @stack
  @parent

  def initialize()
    @stack = []
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
