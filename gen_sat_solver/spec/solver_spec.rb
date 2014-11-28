#!/usr/bin/env ruby
require 'rspec'
require_relative 'spec_helper'
require_relative '../instance'
require_relative '../solver'
require_relative '../creature'
require_relative '../loader'

describe Solver do

  before do
    @c = 100
    @g = 1000
    a = []
	a << [1, 2, 3]
	a << [-1, -2, 3]
	a << [1, -2, -3]
	@inst = Instance.new(a, 3)
	@sol = Solver.new(@inst, @c, @g)
  end

  context 'initializes with instance' do
    it { expect(@sol.formula_length).to eq 3 }
	it { expect(@sol.pop_size).to eq 100 }
	it { expect(@sol.gen_count).to eq 1000 }
  end
  
  context 'combines' do    
    it { expect(@sol.combine([0, 0, 0], [1, 1, 1], 0)).to eq [1, 1, 1] }
	it { expect(@sol.combine([0, 0, 0], [1, 1, 1], 1)).to eq [0, 1, 1] }
	it { expect(@sol.combine([0, 0, 0], [1, 1, 1], 2)).to eq [0, 0, 1] }
	it { expect(@sol.combine([0, 0, 0], [1, 1, 1], 3)).to eq [0, 0, 0] }
  end
  
  context 'solves' do
    it { expect(@inst.evaluate_solution(@sol.solve)).to eq 3 }
	it { expect(test("input/sat_5_10.in")).to eq 10 }	
    it { expect(test("input/sat_5_20.in")).to eq 20 }
    it { expect(test("input/sat_5_40.in")).to eq 40 }
    it { expect(test("input/sat_10_50.in")).to eq 50 }
	it { expect(test("input/sat_20_100.in")).to eq 100 }
	it { expect(test("input/sat_30_200.in")).to be > 190 }
    it { expect(test("input/sat_40_200.in")).to be > 190 }
	it { expect(test("input/sat_50_300.in")).to be > 285 }	
  end
  
  context 'is better than random solver' do
    it { expect(test("input/sat_50_300.in")).to be > random_test("input/sat_50_300.in") }
  end
  
  def test(file)
    i = Loader.load(file)
	s = Solver.new(i, 100, 1000)
	i.evaluate_solution(s.solve)	
  end
  
  def random_test(file)
    i = Loader.load(file)
	s = Solver.new(i, 100, 1000)
	i.evaluate_solution(s.random_solve)	
  end

end
