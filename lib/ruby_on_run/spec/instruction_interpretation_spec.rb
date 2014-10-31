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
      dummy.push_int([7])
      expect(dummy.current_stack_frame.top).to eq 7
    end
  end
  
  describe '#push_self' do
    it 'pushes self' do
      dummy.push_self([])
      fail
    end
  end
  
  describe '#set_literal' do
    it 'sets literal' do
	  dummy.current_stack_frame.literals = [ :xxx ]
	  dummy.push_nil([])
      dummy.set_literal([0])
      expect(dummy.current_stack_frame.top).to eq :xxx
    end
  end
  
  describe '#push_literal' do
    it 'pushes literal' do	
      dummy.current_stack_frame.literals = [ :xxx ]  	
      dummy.push_literal([0])
      expect(dummy.current_stack_frame.top).to eq :xxx
    end
  end
  
  describe '#goto' do
    it 'goes to' do	
      dummy.goto([20])
      expect(dummy.current_stack_frame.bytecode_pointer).to eq 20
    end
  end
  
  describe '#goto_if_false' do
    it 'goes to if false' do
      dummy.push_false([])	
      dummy.goto_if_false([20])
      expect(dummy.current_stack_frame.bytecode_pointer).to eq 20
    end
	it 'goes to if nil' do
      dummy.push_nil([])	
      dummy.goto_if_false([20])
      expect(dummy.current_stack_frame.bytecode_pointer).to eq 20
    end
	it 'doesnt goto if true' do
      dummy.push_true([])	
      dummy.goto_if_false([20])
      expect(dummy.current_stack_frame.bytecode_pointer).not_to eq 20
    end
  end
  
  describe '#goto_if_false' do
    it 'doesnt goto if false' do
      dummy.push_false([])	
      dummy.goto_if_true([20])
      expect(dummy.current_stack_frame.bytecode_pointer).not_to eq 20
    end
	it 'doesnt goto if nil' do
      dummy.push_nil([])	
      dummy.goto_if_true([20])
      expect(dummy.current_stack_frame.bytecode_pointer).not_to eq 20
    end
	it 'goes to if true' do
      dummy.push_true([])	
      dummy.goto_if_true([20])
      expect(dummy.current_stack_frame.bytecode_pointer).to eq 20
    end
  end
  
  describe '#ret' do
    it 'returns to parent stack frame if not nil' do
	  parent = VMStackFrame.new
	  dummy.current_stack_frame.parent = parent
	  dummy.push_true([])
      top = dummy.current_stack_frame.top	
      dummy.ret([])
      expect(dummy.current_stack_frame).to be parent
	  expect(parent.top).to be top 
    end
	it 'ends execution if parent is nil' do
	  dummy.push_true([])
      dummy.ret([])
      expect(dummy.current_stack_frame).to eq nil
    end
  end

end
