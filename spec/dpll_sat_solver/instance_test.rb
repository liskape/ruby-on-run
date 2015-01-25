require_relative 'instance'

a = []
a << [1, 2, 3]
a << [-1, -2, 3]
a << [-1, -2, -3]
inst = Instance.new(a, 3)
puts inst.size
puts inst.var_count
puts inst.evaluate_solution(7, 3)
puts inst.evaluate_solution(3, 2)
puts inst.evaluate_solution(3, 3)
puts inst.evaluate_solution(5, 3)
puts inst.best_solution
