# main class
class RubyOnRun::VirtualMachine

  include InstructionInterpretation

  def initialize(stream)
    @stream = stream

    @code = RubyOnRun::Bytecode.load(@stream).body
    @current_stack_frame = RubyOnRun::StackFrame.new(@code)
    @vm_stack = RubyOnRun::Stack.new @current_stack_frame
    @classes = []
    # initialize other things ...
    
  end

  def run
    debug = false
    while @current_stack_frame
      instruction = @current_stack_frame.next_instruction
      instruction.print if debug     
      send instruction.name, instruction.param_hash
      if debug
        p 'top = ' + @current_stack_frame.top.to_s
        p 'locals = ' + @current_stack_frame.locals.to_s
        p '==========='
      end      
    end

    @return_value
  end

  def open_class(scope, dunno1, class_name)
    @current_stack_frame.binding[class_name] = RubyOnRun::RClass.new
  end

  # def call_under(dunno1, scope, klass)
  #   binding.pry
  #   true
  # end

end
