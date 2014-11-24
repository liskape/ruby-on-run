# main class
class RubyOnRun::VirtualMachine

  include InstructionInterpretation

  DEBUG = false

  def initialize(stream)
    @code = RubyOnRun::Bytecode.load(stream).body # compiledCode
    # @vm_stack = RubyOnRun::Stack.new context

    @classes = {} # HEAP in the future
  end

  def run
    interpret(@code, nil, nil)
  end

  def interpret(code, scope, klass)
    context = RubyOnRun::StackFrame.new(code)
    while context
      instruction = context.next_instruction
      break if instruction.nil?
      instruction.print if DEBUG     
      send instruction.name, instruction.param_hash, context
      if DEBUG
        p 'top = ' + context.top.to_s if context.top
        p 'locals = ' + context.locals.to_s
        p 'binding = ' + context.binding.to_s
        p '==========='
      end      
    end
    @return_value
  end

  def invoke

  end

  def open_class(scope, dunno1, class_name)
    classes[class_name] = RubyOnRun::RClass.new
  end

  # def call_under(dunno1, scope, klass)
  #   binding.pry
  #   true
  # end

end
