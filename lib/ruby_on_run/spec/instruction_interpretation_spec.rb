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

  subject(:dummy) { Dummy.new(VMStackFrame.new) }

  before(:each) do
    dummy.extend(InstructionInterpretation)
  end

  describe '#push_nil' do
    it 'pushes nil' do
      dummy.push_nil([])
      expect(dummy.current_stack_frame.top).to eq nil
    end
  end
  
  describe '#push_true' do
    it 'pushes true' do
      dummy.push_true([])
      expect(dummy.current_stack_frame.top).to eq true
    end
  end
  
  describe '#push_false' do
    it 'pushes false' do
      dummy.push_false([])
      expect(dummy.current_stack_frame.top).to eq false
    end
  end
  
  describe '#push_int' do
    it 'pushes int' do
      dummy.push_int([1])
      expect(dummy.current_stack_frame.top).to eq 1
    end
  end
  
  describe '#push_self' do
    it 'pushes self' do
      dummy.push_self([])
      fail
    end
  end

end
