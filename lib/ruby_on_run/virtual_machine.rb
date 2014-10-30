# main class
class RubyOnRun::VirtualMachine

  @vm_stack
  @current_stack_frame  

  def initialize(stream)
  end

  def run
    # parse stream
    # interpret instructions
  end
  
  def noop
  
  end
  
  def push_nil(args)
    @current_stack_frame.push(nil)
  end
  
  def push_true(args)
    @current_stack_frame.push(true)
  end
  
  def push_false(args)
    @current_stack_frame.push(false)
  end
  
  def push_int(args)
    @current_stack_frame.push(args[0])
  end
  
  def push_self(args)
    # TODO
  end
  
  def set_literal(args)
    @current_stack_frame.pop
	literal = @current_stack_frame.literals[args[0]]
	@current_stack_frame.push(literal)
  end
  
  def push_literal(args)
    literal = @current_stack_frame.literals[args[0]]
	@current_stack_frame.push(literal)
  end
  
  def goto(args)
    @current_stack_frame.bytecode_pointer = args[0]
  end
  
  def goto_if_false(args)
    top = @current_stack_frame.pop
    @current_stack_frame.bytecode_pointer = args[0] if top.nil? || !top
  end
  
  def goto_if_true(args)
    top = @current_stack_frame.pop
    @current_stack_frame.bytecode_pointer = args[0] if !top.nil? && top
  end
  
  def swap_stack(args)
    top1 = @current_stack_frame.pop
	top2 = @current_stack_frame.pop
	@current_stack_frame.push(top1)
	@current_stack_frame.push(top2)
  end
  
  def dup_top(args)
    top = @current_stack_frame.top
	@current_stack_frame.push(top.clone)	
  end
  
  def dup_many(args)
    top_x = []
	args[0].times top_x.push(@current_stack_frame.pop)	
	top_x.reverse!
	top_x.each { |x| @current_stack_frame.push(x.clone) }
	top_x.each { |x| @current_stack_frame.push(x) }
  end
  
  def pop()
    @current_stack_frame.pop
  end
  
end
