require 'rspec'
require_relative 'spec_helper'
require_relative '../instruction_interpretation'
require_relative '../vm_stack_frame'

class Dummy
  attr_accessor :current_stack_frame

  def initialize(frame)
    @current_stack_frame = frame
    extend(InstructionInterpretation)
  end
end

describe 'InstructionInterpretation' do

  subject(:dummy) { Dummy.new(RubyOnRun::VMStackFrame.new) }

  before(:each) do
    dummy.extend(InstructionInterpretation)
  end

  describe '#push_nil' do
    it 'pushes nil' do
      dummy.push_nil([])
      expect(dummy.current_stack_frame.top).to eq nil
    end
  end

end
