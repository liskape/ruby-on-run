#!/usr/bin/env ruby
require 'rspec'
require_relative 'spec_helper'
require_relative '../instance'
require_relative '../loader'

describe Loader do

  context 'initializes with instance' do
    it { expect(Loader.load("input/sat_5_10.in").var_count).to eq 5 }
    it { expect(Loader.load("input/sat_5_10.in").size).to eq 10 }	
  end

end