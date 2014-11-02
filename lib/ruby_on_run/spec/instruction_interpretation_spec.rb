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

class DummyModule
  attr_accessor :alfa
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
	  expect(dummy.return_value).to eq true
    end
  end
  
  describe '#swap_stack' do
    it 'swaps stack' do
      dummy.push_false([])	
	  dummy.push_true([])
      dummy.swap_stack([])
      expect(dummy.current_stack_frame.pop).to eq false
	  expect(dummy.current_stack_frame.top).to eq true
    end
  end
  
  describe '#dup_top' do
    it 'dups top' do
	  dummy.push_false([])	
	  dummy.push_true([])
      dummy.dup_top([])
      expect(dummy.current_stack_frame.pop).to eq true
	  expect(dummy.current_stack_frame.top).to eq true
    end
  end
  
  describe '#dup_many' do
    it 'dups many' do
	  dummy.push_false([])
	  dummy.push_false([]) 
	  dummy.push_false([])	
	  dummy.push_true([])
      dummy.dup_many([2])
      expect(dummy.current_stack_frame.pop).to eq true
	  expect(dummy.current_stack_frame.pop).to eq false
	  expect(dummy.current_stack_frame.pop).to eq true
	  expect(dummy.current_stack_frame.pop).to eq false
    end
  end

  describe '#pop' do
    it 'pops' do
	  dummy.push_true([])
      expect(dummy.pop([])).to eq true
    end
  end	

  describe '#pop_many' do
    it 'pops many' do
	  dummy.push_false([])
	  dummy.push_true([])
      expect(dummy.pop([])).to eq true
	  expect(dummy.pop([])).to eq false
    end
  end
  
  describe '#rotate' do
    it 'rotates' do
	  dummy.push_false([])
	  dummy.push_true([])
	  dummy.push_false([])
	  dummy.push_true([])
	  dummy.rotate([4])
      expect(dummy.pop([])).to eq false
	  expect(dummy.pop([])).to eq true
	  expect(dummy.pop([])).to eq false
	  expect(dummy.pop([])).to eq true
    end
  end
	
  describe '#move_down' do
    it 'moves down' do
	  dummy.push_false([])
	  dummy.push_false([])
	  dummy.push_false([])
	  dummy.push_true([])
	  dummy.move_down([3])
      expect(dummy.pop([])).to eq false
	  expect(dummy.pop([])).to eq false
	  expect(dummy.pop([])).to eq false
	  expect(dummy.pop([])).to eq true
    end
  end
  
  describe '#set_local' do
    it 'sets local' do
	  dummy.current_stack_frame.locals[:var] = 15
	  dummy.push_int([22])
	  dummy.set_local([:var])
	  expect(dummy.current_stack_frame.locals[:var]).to eq 22
	end
	it 'doesnt change top of stack' do
	  dummy.current_stack_frame.locals[:var] = 15
	  dummy.push_int([22])
	  dummy.set_local([:var])
	  expect(dummy.pop([])).to eq 22
	end
  end
  
  describe '#push_local' do
    it 'pushes local' do
	  dummy.current_stack_frame.locals[:var] = 15
	  dummy.push_local([:var])
	  expect(dummy.pop([])).to eq 15
	end
  end
  
  describe '#push_local_depth' do
    it 'pushes local to depth' do
	  parent = VMStackFrame.new
	  parent.locals[:var] = 15
	  parent.locals[:a] = 22	  
	  dummy.current_stack_frame.parent = parent
	  dummy.push_local_depth([1, 1])
	  expect(dummy.pop([])).to eq 22
	end
  end
  
  describe '#set_local_depth' do
    it 'sets local to depth' do
	  parent = VMStackFrame.new
	  parent.locals[:var] = 15
	  parent.locals[:a] = 22	  
	  dummy.current_stack_frame.parent = parent
	  dummy.push_int([44])
	  dummy.set_local_depth([1, 1])
	  expect(parent.locals[:a]).to eq 44
	end
  end
  
  describe '#make_array' do
    it 'makes array' do
	  dummy.push_int([1])
	  dummy.push_int([2])
	  dummy.push_int([3])
	  dummy.make_array([3])
	  expect(dummy.current_stack_frame.top).to eq [1, 2, 3]
	end
  end
  
  describe '#cast_array' do
    it 'casts array' do
	  fail
	end
  end
  
  describe '#shift_array' do
    it 'shifts array' do
	  dummy.push_int([1])
	  dummy.push_int([2])
	  dummy.push_int([3])
	  dummy.make_array([3])
	  dummy.shift_array([])
	  expect(dummy.current_stack_frame.pop).to eq 1
	  expect(dummy.current_stack_frame.top).to eq [2, 3]
	end
  end
  
  describe '#set_ivar' do
    it 'sets ivar' do
	  fail
	end
  end
  
  describe '#push_ivar' do
    it 'pushes ivar' do
	  fail
	end
  end
  
  describe '#push_const' do
    it 'pushes const' do
	  dummy.current_stack_frame.constants[:var] = 15
	  dummy.push_const([:var])
	  expect(dummy.pop([])).to eq 15
	end
	it 'raises exception' do
	  dummy.push_const([:xxx])
	  expect(dummy.pop([]).class.name).to eq "NameError"
	end
  end
  
  describe '#set_const' do
    it 'sets const' do
	  dummy.current_stack_frame.constants[:var] = 15
	  dummy.push_int([22])
	  dummy.set_const([:var])
	  expect(dummy.current_stack_frame.constants[:var]).to eq 22
	end
	it 'doesnt change top of stack' do
	  dummy.current_stack_frame.constants[:var] = 15
	  dummy.push_int([22])
	  dummy.set_const([:var])
	  expect(dummy.pop([])).to eq 22
	end
  end
  
  describe '#set_const_at' do
    it 'sets const at' do
	  mod = DummyModule.new
	  dummy.current_stack_frame.push(mod)
	  dummy.push_int([22])
	  dummy.set_const_at([:alfa])
	  expect(mod.alfa).to eq 22
	end
	it 'doesnt change top of stack' do
	  dummy.current_stack_frame.push(DummyModule.new)
	  dummy.push_int([22])
	  dummy.set_const_at([:alfa])
	  expect(dummy.pop([])).to eq 22
	end
  end
  
end
