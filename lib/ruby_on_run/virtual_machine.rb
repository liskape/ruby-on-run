# main class
class RubyOnRun::VirtualMachine

  include InstructionInterpretation

  def initialize(stream)
    @stream = stream
    @current_stack_frame = RubyOnRun::VMStackFrame.new
    @vm_stack = RubyOnRun::VMStack.new @current_stack_frame

    # initialize other things ...
  end

  def run
    # code = RubyOnRun::Bytecode.load(@stream).body
    # code.iseq <- stream of instruction and params
    # repeat
      # instruction = RubyOnRun::InstructionSet.parse_instruction
      # send instruction.name, instruction.arg_map <- this will call methods defined bellow
	@return_value
  end
  
end
