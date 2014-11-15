module InstructionInterpretation

  attr_accessor :return_value

  def method_missing(meth, *args, &block)
    raise "It is not defined how to interpret #{meth} with args #{args}"
  end

  def noop(args)
  
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
    @current_stack_frame.push args[:number]
  end
  
  def push_self(args)
    @current_stack_frame.push @current_stack_frame.self
  end
  
  def set_literal(args)
    @current_stack_frame.pop
    literal = @current_stack_frame.literals[args[:literal]]
    @current_stack_frame.push(literal)
  end
  
  def push_literal(args)
    literal = @current_stack_frame.literals[args[:literal]]
    @current_stack_frame.push(literal)
  end
  
  def goto(args)
    @current_stack_frame.bytecode_pointer = args[:location]
    @jump = true
  end
  
  def goto_if_false(args)
    top = @current_stack_frame.pop
    if top.nil? || !top
      @current_stack_frame.bytecode_pointer = args[:location]
      @jump = true
    end
  end
  
  def goto_if_true(args)
    top = @current_stack_frame.pop
    if !top.nil? && top
      @current_stack_frame.bytecode_pointer = args[:location]
      @jump = true
    end
  end
  
  def ret(args)
    top = @current_stack_frame.pop
    if @current_stack_frame.parent.nil?
      @return_value = top
      @current_stack_frame = nil
    else
      @current_stack_frame.parent.push(top)
      @current_stack_frame = @current_stack_frame.parent
    end
  end
  
  def swap_stack(args)
    top1 = @current_stack_frame.pop
    top2 = @current_stack_frame.pop
    @current_stack_frame.push(top1)
    @current_stack_frame.push(top2)
  end
  
  def dup_top(args)
    top = @current_stack_frame.top
    # what about top.respons_to? :clone
  	if top.class.name == "NilClass" || top.class.name == "FalseClass" || top.class.name == "TrueClass" || top.class.name == "Fixnum" || top.class.name == "Symbol"
      @current_stack_frame.push(top) 
    else
	  @current_stack_frame.push(top.clone)    
	end
  end
  
  def dup_many(args)
    top_x = []
    args[:count].times { top_x.push(@current_stack_frame.pop) }  
    top_x.reverse!
    top_x.each do |x|
      if x.class.name == "NilClass" || x.class.name == "FalseClass" || x.class.name == "TrueClass" || x.class.name == "Fixnum"	 
	    @current_stack_frame.push(x)
	  else
	    @current_stack_frame.push(x.clone)
      end		
    end
    top_x.each { |x| @current_stack_frame.push(x) }
  end
  
  def pop(args)
    @current_stack_frame.pop
  end
  
  def pop_many(args)
    args[:count].times @current_stack_frame.pop
  end
  
  def rotate(args)
    top_x = []
    args[:count].times { top_x.push(@current_stack_frame.pop) }
    top_x.each { |x| @current_stack_frame.push(x) } 
  end
  
  def move_down(args)
    top = @current_stack_frame.pop
    top_x = []
    args[:positions].times { top_x.push(@current_stack_frame.pop) }
    @current_stack_frame.push(top)
    top_x.reverse!
    top_x.each { |x| @current_stack_frame.push(x) }   
  end
  
  def set_local(args)
    @current_stack_frame.binding[@current_stack_frame.locals[args[:local]]] = @current_stack_frame.top
  end 
  
  def push_local(args)
    @current_stack_frame.push @current_stack_frame.locals[args[:local]]
  end 
  
  def push_local_depth(args)
    frame = @current_stack_frame
    args[:depth].times { frame = frame.parent }
    keys = frame.locals.keys
    @current_stack_frame.push(frame.locals[keys[args[:index]]])
  end 

  def set_local_depth(args)
    frame = @current_stack_frame
    args[:depth].times { frame = frame.parent }
    key = frame.locals.keys[args[:index]]
    frame.locals[key] = @current_stack_frame.top
  end
  
  def passed_arg(args)
  
  end
  
  def push_current_exception(args)
  
  end
  
  def clear_exception(args)
  
  end
  
  def push_exception_state(args)
  
  end
  
  def restore_exception_state(args)
  
  end
  
  def raise_exc(args)
  
  end
  
  def setup_unwind(args)
  
  end
  
  def pop_unwind(args)
  
  end
  
  def raise_return(args)
  
  end
  
  def ensure_return(args)
  
  end
  
  def raise_break(args)
  
  end
  
  def reraise(args)
  
  end

  def make_array(args)
    a = []
    args[:count].times { a.push(@current_stack_frame.pop) }
    a.reverse!
    @current_stack_frame.push(a)
  end
  
  def cast_array(args)
    # TODO
  end

  def shift_array(args)
    a = @current_stack_frame.pop
    first = a.shift
    @current_stack_frame.push(a)
    @current_stack_frame.push(first)  
  end

  def set_ivar(args)
    top = @current_stack_frame.top
    @current_stack_frame.instance.send(args[:literal].to_s + '=', top)
  end

  def push_ivar(args)
    @current_stack_frame.push(@current_stack_frame.instance.send(args[:literal]))
  end  
  
  def push_const(args)
    if @current_stack_frame.constants.keys.include?(args[:literal])
      @current_stack_frame.push(@current_stack_frame.constants[args[:literal]])
	else
	  # TODO push NameError 
	end
  end
  
  def set_const(args)
    @current_stack_frame.constants[args[:literal]] = @current_stack_frame.top
  end
  
  def set_const_at(args)
    top = @current_stack_frame.pop
	mod = @current_stack_frame.pop
	mod.send(args[:literal].to_s + "=", top)
	@current_stack_frame.push(top)
  end
  
  def find_const(args)
    mod = @current_stack_frame.pop
    if mod.methods.include?(args[:literal])
      @current_stack_frame.push(mod.send(args[:literal]))
    else
      # TODO push NameError
    end
  end

  def meta_push_1(args)
    @current_stack_frame.push(1)
  end

  def meta_push_2(args)
    @current_stack_frame.push(2)
  end

  def send_stack(args, parameters = [])
    args[:count].times { parameters <<  @current_stack_frame.pop}
    receiver = @current_stack_frame.pop
    message  = @current_stack_frame.literals[args[:literal]]
    receiver = resolve_receiver(receiver)
    parameters = resolve_parameters(parameters)
    @current_stack_frame.push receiver.send(message, *parameters)
  end

  def string_dup(args)
  end

  def allow_private(args)
  end

  def push_rubinius(args)
    @current_stack_frame.push self
  end

  def push_scope(args)
    @current_stack_frame.push RubyOnRun::Scope.new
  end

  def create_block(args)
    code = @current_stack_frame.literals[args[:literal]]
    @current_stack_frame.push RubyOnRun::BlockEnvironment.new(code)
  end
  
  def allow_private(args)
    self.allow_private = true
  end

  private

  def resolve_parameters(parameters)
    parameters.map{ |p| resolve_receiver(p) }
  end

  def resolve_receiver(receiver)
    if receiver.is_a? Symbol
      resolve_receiver(@current_stack_frame.binding[receiver]) || receiver
    else
      receiver
    end
  end

  def push_const_fast(args)
    constant = @current_stack_frame.literals[args[:literal]]
    @current_stack_frame.push constant
  end
  
  def check_serial(args) #optimization
    @current_stack_frame.push false
  end
end
