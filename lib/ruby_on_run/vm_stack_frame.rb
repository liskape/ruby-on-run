# class representing a frame in VMStack
class RubyOnRun::VMStackFrame

  @method
  @bytecode
  @bytecode_pointer
  @literals
  @args
  @locals
  @stack
  @parent

  def initialize()
  end  
  
  def push(x)
    stack.push(x)
  end
  
  def pop
    stack.pop
  end
  
  def top
    stack.top
  end
  
end