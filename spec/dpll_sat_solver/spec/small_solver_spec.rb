#!/usr/bin/env ruby
require 'rspec'
require_relative 'spec_helper'
require_relative '../instance'
require_relative '../solver'
require_relative '../loader'

describe Solver do
 
  context 'solves' do
    it { expect(test("spec/dpll_sat_solver/input/sat_5_10.in")). to eq true }
  end
  
  def test(file)
    Solver.new.solve(Loader.load(file))
  end

end
