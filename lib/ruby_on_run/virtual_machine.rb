# main class
class RubyOnRun::VirtualMachine

  include InstructionInterpretation

  def initialize(stream)
    @stream = stream

    @code = RubyOnRun::Bytecode.load(@stream).body    
    @classes = {}
    # initialize other things ...    
  end

  def run
    interpret(@code, nil, nil)
  end

  def interpret(code, scope, klass)
    frame = RubyOnRun::StackFrame.new(@code)
    @vm_stack = RubyOnRun::Stack.new frame
    debug = false
    while frame
      instruction = frame.next_instruction
      break if instruction.nil?
      instruction.print if debug     
      send instruction.name, instruction.param_hash, frame
      if debug
        p 'top = ' + frame.top.to_s if frame.top
        p 'locals = ' + frame.locals.to_s
		p 'binding = ' + frame.binding.to_s
        p '==========='
      end      
    end
    @return_value
  end

  def open_class(scope, dunno1, class_name)
    classes[class_name] = RubyOnRun::RClass.new
  end

  # def call_under(dunno1, scope, klass)
  #   binding.pry
  #   true
  # end

end
