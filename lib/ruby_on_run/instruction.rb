# representing one instruction with operand
class RubyOnRun::Instruction

  attr_reader :name

  def initialize(name)
    @name = name
  end
end
