module InstructionInterpretation

  attr_accessor :return_value

  def method_missing(meth, *args, &block)
    raise "It is not defined how to interpret #{meth} with args #{args}"
  end

  def noop(args, context)
  
  end
  
  def push_nil(args, context)
    context.push(nil)
  end
  
  def push_true(args, context)
    context.push(true)
  end
  
  def push_false(args, context)
    context.push(false)
  end
  
  def push_int(args, context)
    context.push args[:number]
  end
  
  def push_self(args, context)
    context.push context.self
  end
  
  def set_literal(args, context)
    context.pop
    literal = context.literals[args[:literal]]
    context.push(literal)
  end
  
  def push_literal(args, context)
    literal = context.literals[args[:literal]]
    context.push(literal)
  end
  
  def goto(args, context)
    context.bytecode_pointer = args[:location]
    @jump = true
  end
  
  def goto_if_false(args, context)
    top = context.pop
    if top.nil? || !top
      context.bytecode_pointer = args[:location]
      @jump = true
    end
  end
  
  def goto_if_true(args, context)
    top = context.pop
    if !top.nil? && top
      context.bytecode_pointer = args[:location]
      @jump = true
    end
  end
  
  def ret(args, context)
    top = context.pop
    if context.parent.nil?
      @return_value = top
      context = nil
    else
      context.parent.push(top)
      context = context.parent
    end
  end
  
  def swap_stack(args, context)
    top1 = context.pop
    top2 = context.pop
    context.push(top1)
    context.push(top2)
  end
  
  def dup_top(args, context)
    top = context.top
    # what about top.respons_to? :clone
  	if top.class.name == "NilClass" || top.class.name == "FalseClass" || top.class.name == "TrueClass" || top.class.name == "Fixnum" || top.class.name == "Symbol"
      context.push(top) 
    else
  	  context.push(top.clone)    
  	end
    true
  end
  
  def dup_many(args, context)
    top_x = []
    args[:count].times { top_x.push(context.pop) }  
    top_x.reverse!
    top_x.each do |x|
      if x.class.name == "NilClass" || x.class.name == "FalseClass" || x.class.name == "TrueClass" || x.class.name == "Fixnum"	 
	    context.push(x)
	  else
	    context.push(x.clone)
      end		
    end
    top_x.each { |x| context.push(x) }
  end
  
  def pop(args, context)
    context.pop
  end
  
  def pop_many(args, context)
    args[:count].times context.pop
  end
  
  def rotate(args, context)
    top_x = []
    args[:count].times { top_x.push(context.pop) }
    top_x.each { |x| context.push(x) } 
  end
  
  def move_down(args, context)
    top = context.pop
    top_x = []
    args[:positions].times { top_x.push(context.pop) }
    context.push(top)
    top_x.reverse!
    top_x.each { |x| context.push(x) }   
  end
  
  def set_local(args, context)
    context.binding[context.locals[args[:local]]] = context.top
  end 
  
  def push_local(args, context)
    context.push context.binding[context.locals[args[:local]]]
  end 
  
  def push_local_depth(args, context)
    context = context
    args[:depth].times { context = context.parent }
    keys = context.locals.keys
    context.push(context.locals[keys[args[:index]]])
  end 

  def set_local_depth(args, context)
    context = context
    args[:depth].times { context = context.parent }
    key = context.locals.keys[args[:index]]
    context.locals[key] = context.top
  end
  
  def passed_arg(args, context)
  
  end
  
  def push_current_exception(args, context)
  
  end
  
  def clear_exception(args, context)
  
  end
  
  def push_exception_state(args, context)
  
  end
  
  def restore_exception_state(args, context)
  
  end
  
  def raise_exc(args, context)
  
  end
  
  def setup_unwind(args, context)
  
  end
  
  def pop_unwind(args, context)
  
  end
  
  def raise_return(args, context)
  
  end
  
  def ensure_return(args, context)
  
  end
  
  def raise_break(args, context)
  
  end
  
  def reraise(args, context)
  
  end

  def make_array(args, context)
    a = []
    args[:count].times { a.push(context.pop) }
    a.reverse!
    context.push(a)
  end
  
  def cast_array(args, context)
    # TODO
  end

  def shift_array(args, context)
    a = context.pop
    first = a.shift
    context.push(a)
    context.push(first)  
  end

  def set_ivar(args, context)
    top = context.top
    context.instance.send(args[:literal].to_s + '=', top)
  end

  def push_ivar(args, context)
    context.push(context.instance.send(args[:literal]))
  end  
  
  def push_const(args, context)
    if context.constants.keys.include?(args[:literal])
      context.push(context.constants[args[:literal]])
	else
	  # TODO push NameError 
	end
  end
  
  def set_const(args, context)
    context.constants[args[:literal]] = context.top
  end
  
  def set_const_at(args, context)
    top = context.pop
    mod = context.pop
    mod.send(args[:literal].to_s + "=", top)
    context.push(top)
  end
  
  def find_const(args, context)
    mod = context.pop
    if mod.methods.include?(args[:literal])
      context.push(mod.send(args[:literal]))
    else
      # TODO push NameError
    end
  end

  def push_cpath_top(args, context)
    context.push(Object)
  end

  def find_const_fast(args, context)
    find_const(args, context)
  end

  def meta_push_0(args, context)
    context.push(0)
  end

  def meta_push_1(args, context)
    context.push(1)
  end

  def meta_push_2(args, context)
    context.push(2)
  end

  def string_dup(args, context)
  end

  def allow_private(args, context)
    context.self.allow_private = true
  end

  def push_rubinius(args, context)
    context.push self
  end

  def push_scope(args, context)
    context.push context.current_class
  end

  def add_scope(args, context)
    _module = context.pop
    context.current_class = _module
  end

  def set_stack_local(args, context)
  end

  def push_stack_local(args, context)
    true
  end

  # Push the VariableScope for the current method/block invocation on the stack.
  def push_variables(args, context)
    context.push context.current_class
  end

  def create_block(args, context)
    code = context.literals[args[:literal]]
    context.push RubyOnRun::BlockEnvironment.new(code, self)
  end

  def send_stack(args, parameters = [], context)
    args[:count].times { parameters << context.pop}
    receiver = context.pop
    message  = context.literals[args[:literal]]
    receiver = resolve_receiver(receiver, context)
    #p 'receiver = ' + receiver.to_s 
    parameters = resolve_parameters(parameters, context)
    #p 'parameters = ' + parameters.to_s
    context.push receiver.send(message, *parameters)
  end


  private

  def resolve_parameters(parameters, context)
    parameters.map{ |p| resolve_receiver(p, context) }
    parameters.reverse!
  end

  def resolve_receiver(receiver, context)
    if receiver.is_a? Symbol
    
      return @classes[receiver] if receiver[0].upcase == receiver[0]

      while (true)
        if !context.binding.has_key?(receiver)
          context = context.parent 
        else
          break
        end        
        return nil if context.nil?
      end
      resolve_receiver(context.binding[receiver], context) || receiver
    else
      receiver
    end
  end

  def push_const_fast(args, context)
    constant = context.literals[args[:literal]]
    context.push constant
  end  
  
  def check_serial(args, context) #optimization
    context.push false
  end
end
