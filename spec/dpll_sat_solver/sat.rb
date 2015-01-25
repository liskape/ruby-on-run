require_relative 'solver'
require_relative 'loader'

puts Solver.new.solve(Loader.load("input/sat_5_10.in"))
puts Solver.new.solve(Loader.load("input/sat_5_20.in"))
puts Solver.new.solve(Loader.load("input/sat_5_40.in"))
puts Solver.new.solve(Loader.load("input/sat_10_50.in"))

