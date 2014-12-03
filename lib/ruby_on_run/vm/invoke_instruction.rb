module RubyOnRun::VM::InvokeInstructionInterpretation

  def send_stack_with_block(args, parameters = [], context)
    debug = false
    block = context.pop
    args[:count].times { parameters << context.pop}
    receiver = context.pop
    message  = context.literals[args[:literal]]
    receiver = resolve_receiver(receiver, context)
    parameters = resolve_parameters(parameters, context)
    if debug
      p 'block = ' + block.to_s
      p 'receiver = ' + receiver.to_s
      p 'parameters = ' + parameters.to_s
      p 'message = ' + message.to_s
    end
    result = if receiver.is_a? RubyOnRun::VM::RObject
      # heavy lifting here
      # method lookup and shit
      code = receiver.klass.method(message)
      new_context = RubyOnRun::VM::Context.new(code, receiver.klass, receiver, context, {})
      interpret(new_context)
    else
      # primitive for now
      # p receiver.methods
      receiver.send(message, *parameters)
    end
    p 'result = ' + result.to_s if debug
    evaluate_block(result, parameters, block)
    context.push result
  end

  def send_stack(args, parameters = [], context)
    args[:count].times { parameters << context.pop}
    receiver = context.pop
    message  = context.literals[args[:literal]]

    receiver = resolve_receiver(receiver, context)
    parameters = resolve_parameters(parameters, context)

    if receiver.is_a?(RubyOnRun::VM::VirtualMachine) || receiver.is_a?(RubyOnRun::VM::BlockEnvironment)
      context.push receiver.send(message, *parameters)
    else
      code = receiver.get_singleton_method(message)
      code ||= find_method_in_chain(receiver.klass, message, context)

      _binding = create_binding(code, parameters)
      new_context = RubyOnRun::VM::Context.new(code, receiver.klass, receiver, context, _binding)
      interpret(new_context) # result is pushed on parent context stack in ret instruction
    end
  end

  # not in rubinius
  def invoke_native(args, context)
    # in future NativeCompiledCode will have this instruction + ret
    # maybe send to kernel or something
    context.push context.compiled_code.method.call(*context.binding.values.compact)
  end

  def send_method(args, context)
    send_stack(args.merge(count: 0), context)
  end

  def zsuper(args, context)
    message  = context.literals[args[:literal]]
    receiver = context.pop

    # TODO arity
    code = find_method_in_chain(resolve_receiver(receiver.klass.superklass, context), message, context)
    _binding = create_binding(code, [])
    
    new_context = RubyOnRun::VM::Context.new(code, receiver.klass, receiver, context, _binding)
    interpret(new_context) # result is pushed on parent context stack in ret instruction
  end
    
  private
  
  # method lookup in ancesstor chain
  def find_method_in_chain(klass, method_name, context)
    raise "No method error #{method_name}" if klass.nil?

    if klass.method(method_name)
      klass.method(method_name)
    else
      find_method_in_chain(resolve_receiver(klass.superklass, context), method_name, context)
    end
  end

  def create_binding(code, parameters)
    Hash[code.local_names.zip(parameters)]
  end
  
  def evaluate_block(enumerator, parameters, block)
    enumerator.each do |x|      
      new_context = RubyOnRun::VM::Context.new(block.compiled_code, nil, nil, block.parent_context, {})
      new_context.binding[new_context.locals[0]] = x      
      interpret(new_context)
    end
  end

  def resolve_parameters(parameters, context)
    parameters.map{ |p| resolve_receiver(p, context) }
    parameters.reverse!
  end

  # TODO: its job of context
  # tell dont ask is violated here
  def resolve_receiver(receiver, context)

    if receiver.is_a? Symbol
      # that means Constant
      return @classes[receiver] if receiver[0].upcase == receiver[0] #its a our class!

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

end
