# class representing a frame in VMStack
class RubyOnRun::StackFrame
  attr_accessor :literals, :bytecode_pointer, :parent, :locals, :constants, :instance, :method, :bytecode, :args, :self, :binding 

  def initialize(compiled_code)
    @compiled_code = compiled_code
    @stack = []
    @literals = compiled_code.literals
    @bytecode_pointer = 0
    @bytecode = compiled_code.iseq
    @self = MainContext.new

    @locals = compiled_code.local_names
    @binding = {}
  end

  def next_instruction
    return nil if @bytecode_pointer >= @bytecode.length
    i = RubyOnRun::InstructionSet.parse_instruction(@bytecode[@bytecode_pointer..-1])
    if @jump
      @jump = false
    else
      @bytecode_pointer += 1 + i.args.size
    end
    i
  end

  def push(x)
    @stack.push(x)
  end

  def pop
    @stack.pop
  end

  def top
    top = @stack.pop
    @stack.push(top)
    top
  end

  class MainContext

    attr_accessor :allow_private
  
    def initialize
      @allow_private = false
    end

    # def send(meth, *args, &block)
    #   raise "Method #{meth} is not implemented yet"
    # end	

  end

end
