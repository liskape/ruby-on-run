# main class
class RubyOnRun::VirtualMachine

  include InstructionInterpretation

  def initialize(stream)
    @stream = stream

    @code = RubyOnRun::Bytecode.load(@stream).body
    @current_stack_frame = RubyOnRun::StackFrame.new(@code)
    @vm_stack = RubyOnRun::Stack.new @current_stack_frame
    # initialize other things ...
  end

  def run
    while @current_stack_frame
      instruction = @current_stack_frame.next_instruction
      # instruction.print
      send instruction.name, instruction.param_hash
    end

    @return_value
  end

end
