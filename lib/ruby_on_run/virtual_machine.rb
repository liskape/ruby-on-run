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
    while @current_stack_frame
      instruction = @current_stack_frame.next_instruction
      #instruction.print
      send instruction.name, instruction.param_hash
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
