#!/usr/bin/env ruby
require 'rspec'
require_relative 'spec_helper'
require_relative '../instance'
require_relative '../solver'
require_relative '../loader'

describe Solver do

  before do
    a = []
	a << [-1]
	a << [-2]
	a << [3]
	@inst = Instance.new(a, 3)
	@sol = Solver.new
  end
  
  context 'solves' do
    it { expect(@sol.solve(@inst)).to eq true }
	it { expect(test("input/sat_5_10.in")). to eq true }
	it { expect(test("input/sat_5_20.in")). to eq true }
	it { expect(test("input/sat_5_40.in")). to eq false }
	it { expect(test("input/sat_10_50.in")). to eq true }
	it { expect(test("input/sat_20_100.in")). to eq false }
	it { expect(test("input/sat_30_100.in")). to eq true }
	it { expect(test("input/sat_30_200.in")). to eq false }
  end
  
  def test(file)
	Solver.new.solve(Loader.load(file))
  end

end
