#!/usr/bin/env ruby
require 'rspec'
require_relative 'spec_helper'
require_relative '../instance'

describe Instance do

  context 'initializes with array' do    
	a = []
	a << [1, 2, 3]
	a << [-1, -2, 3]
	a << [1, -2, -3]
	inst = Instance.new(a, 3)
    it { expect(inst.size).to eq 3 }
	it { expect(inst.var_count).to eq 3 }
	it { expect(inst.evaluate_solution([1, 1, 1])).to eq 3 }
	it { expect(inst.evaluate_solution([0, 0, 0])).to eq 2 }
	it { expect(inst.evaluate_solution([0, 0, 1])).to eq 3 }
	it { expect(inst.best_solution).to eq [1, 1, 1] }
	it { expect(inst.best_satisfied_count).to eq 3 }
  end

end
