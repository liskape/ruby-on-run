# class representing a frame in VMStack
class RubyOnRun::Context
  attr_accessor :literals, :stack, :bytecode_pointer, :parent, :locals, :constants, :instance, :method, :bytecode, :args, :self, :binding, :current_class

  def initialize(compiled_code, current_class, selfie, parent)
    @compiled_code = compiled_code
    @current_class = current_class
    @self = selfie
    @stack = []
    @literals = compiled_code.literals
    @bytecode_pointer = 0
    @bytecode = compiled_code.iseq
    @locals = compiled_code.local_names
    @binding = {}
    @parent = parent
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

  def add_binding(to_add_binding)
    @binding.merge!(to_add_binding)
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

end
