module InstructionInterpretation

  attr_accessor :return_value

  def method_missing(meth, *args, &block)
    raise "It is not defined how to interpret #{meth} with args #{args}"
  end

  def noop(args, frame)
  
  end
  
  def push_nil(args, frame)
    @current_stack_frame.push(nil)
  end
  
  def push_true(args, frame)
    @current_stack_frame.push(true)
  end
  
  def push_false(args, frame)
    @current_stack_frame.push(false)
  end
  
  def push_int(args, frame)
    @current_stack_frame.push args[:number]
  end
  
  def push_self(args, frame)
    @current_stack_frame.push @current_stack_frame.self
  end
  
  def set_literal(args, frame)
    @current_stack_frame.pop
    literal = @current_stack_frame.literals[args[:literal]]
    @current_stack_frame.push(literal)
  end
  
  def push_literal(args, frame)
    literal = @current_stack_frame.literals[args[:literal]]
    @current_stack_frame.push(literal)
  end
  
  def goto(args, frame)
    @current_stack_frame.bytecode_pointer = args[:location]
    @jump = true
  end
  
  def goto_if_false(args, frame)
    top = @current_stack_frame.pop
    if top.nil? || !top
      @current_stack_frame.bytecode_pointer = args[:location]
      @jump = true
    end
  end
  
  def goto_if_true(args, frame)
    top = @current_stack_frame.pop
    if !top.nil? && top
      @current_stack_frame.bytecode_pointer = args[:location]
      @jump = true
    end
  end
  
  def ret(args, frame)
    top = @current_stack_frame.pop
    if @current_stack_frame.parent.nil?
      @return_value = top
      @current_stack_frame = nil
    else
      @current_stack_frame.parent.push(top)
      @current_stack_frame = @current_stack_frame.parent
    end
  end
  
  def swap_stack(args, frame)
    top1 = @current_stack_frame.pop
    top2 = @current_stack_frame.pop
    @current_stack_frame.push(top1)
    @current_stack_frame.push(top2)
  end
  
  def dup_top(args, frame)
    top = @current_stack_frame.top
    # what about top.respons_to? :clone
  	if top.class.name == "NilClass" || top.class.name == "FalseClass" || top.class.name == "TrueClass" || top.class.name == "Fixnum" || top.class.name == "Symbol"
      @current_stack_frame.push(top) 
    else
	  @current_stack_frame.push(top.clone)    
	end
  end
  
  def dup_many(args, frame)
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
  
  def pop(args, frame)
    @current_stack_frame.pop
  end
  
  def pop_many(args, frame)
    args[:count].times @current_stack_frame.pop
  end
  
  def rotate(args, frame)
    top_x = []
    args[:count].times { top_x.push(@current_stack_frame.pop) }
    top_x.each { |x| @current_stack_frame.push(x) } 
  end
  
  def move_down(args, frame)
    top = @current_stack_frame.pop
    top_x = []
    args[:positions].times { top_x.push(@current_stack_frame.pop) }
    @current_stack_frame.push(top)
    top_x.reverse!
    top_x.each { |x| @current_stack_frame.push(x) }   
  end
  
  def set_local(args, frame)
    @current_stack_frame.binding[@current_stack_frame.locals[args[:local]]] = @current_stack_frame.top
  end 
  
  def push_local(args, frame)
    @current_stack_frame.push @current_stack_frame.binding[@current_stack_frame.locals[args[:local]]]
  end 
  
  def push_local_depth(args, frame)
    frame = @current_stack_frame
    args[:depth].times { frame = frame.parent }
    keys = frame.locals.keys
    @current_stack_frame.push(frame.locals[keys[args[:index]]])
  end 

  def set_local_depth(args, frame)
    frame = @current_stack_frame
    args[:depth].times { frame = frame.parent }
    key = frame.locals.keys[args[:index]]
    frame.locals[key] = @current_stack_frame.top
  end
  
  def passed_arg(args, frame)
  
  end
  
  def push_current_exception(args, frame)
  
  end
  
  def clear_exception(args, frame)
  
  end
  
  def push_exception_state(args, frame)
  
  end
  
  def restore_exception_state(args, frame)
  
  end
  
  def raise_exc(args, frame)
  
  end
  
  def setup_unwind(args, frame)
  
  end
  
  def pop_unwind(args, frame)
  
  end
  
  def raise_return(args, frame)
  
  end
  
  def ensure_return(args, frame)
  
  end
  
  def raise_break(args, frame)
  
  end
  
  def reraise(args, frame)
  
  end

  def make_array(args, frame)
    a = []
    args[:count].times { a.push(@current_stack_frame.pop) }
    a.reverse!
    @current_stack_frame.push(a)
  end
  
  def cast_array(args, frame)
    # TODO
  end

  def shift_array(args, frame)
    a = @current_stack_frame.pop
    first = a.shift
    @current_stack_frame.push(a)
    @current_stack_frame.push(first)  
  end

  def set_ivar(args, frame)
    top = @current_stack_frame.top
    @current_stack_frame.instance.send(args[:literal].to_s + '=', top)
  end

  def push_ivar(args, frame)
    @current_stack_frame.push(@current_stack_frame.instance.send(args[:literal]))
  end  
  
  def push_const(args, frame)
    if @current_stack_frame.constants.keys.include?(args[:literal])
      @current_stack_frame.push(@current_stack_frame.constants[args[:literal]])
	else
	  # TODO push NameError 
	end
  end
  
  def set_const(args, frame)
    @current_stack_frame.constants[args[:literal]] = @current_stack_frame.top
  end
  
  def set_const_at(args, frame)
    top = @current_stack_frame.pop
	mod = @current_stack_frame.pop
	mod.send(args[:literal].to_s + "=", top)
	@current_stack_frame.push(top)
  end
  
  def find_const(args, frame)
    mod = @current_stack_frame.pop
    if mod.methods.include?(args[:literal])
      @current_stack_frame.push(mod.send(args[:literal]))
    else
      # TODO push NameError
    end
  end

  def push_cpath_top(args, frame)
    @current_stack_frame.push(Object)
  end

  def find_const_fast(args, frame)
    find_const(args, frame)
  end

  def meta_push_0(args, frame)
    @current_stack_frame.push(0)
  end

  def meta_push_1(args, frame)
    @current_stack_frame.push(1)
  end

  def meta_push_2(args, frame)
    @current_stack_frame.push(2)
  end

  def send_stack(args, parameters = [], frame)
    args[:count].times { parameters << @current_stack_frame.pop}
    receiver = @current_stack_frame.pop
    message  = @current_stack_frame.literals[args[:literal]]
    receiver = resolve_receiver(receiver, frame)
    #p 'receiver = ' + receiver.to_s 
    parameters = resolve_parameters(parameters, frame)
    #p 'parameters = ' + parameters.to_s
    @current_stack_frame.push receiver.send(message, *parameters)
  end

  def string_dup(args, frame)
  end

  def allow_private(args, frame)
    @current_stack_frame.self.allow_private = true
  end

  def push_rubinius(args, frame)
    @current_stack_frame.push self
  end

  def push_scope(args, frame)
    @current_stack_frame.push RubyOnRun::Scope.new
  end

  def create_block(args, frame)
    code = @current_stack_frame.literals[args[:literal]]
    @current_stack_frame.push RubyOnRun::BlockEnvironment.new(code)
  end

  private

  def resolve_parameters(parameters, frame)
    parameters.map{ |p| resolve_receiver(p, frame) }
    parameters.reverse!
  end

  def resolve_receiver(receiver, frame)
    frame = @current_stack_frame
    if receiver.is_a? Symbol
      while (true)
        if !frame.binding.has_key?(receiver)
          frame = frame.parent 
        else
          break
        end        
        return nil if frame.nil?
      end
      resolve_receiver(frame.binding[receiver], frame) || receiver
    else
      receiver
    end
  end

  def push_const_fast(args, frame)
    constant = @current_stack_frame.literals[args[:literal]]
    @current_stack_frame.push constant
  end  
  
  def check_serial(args, frame) #optimization
    @current_stack_frame.push false
  end
end
