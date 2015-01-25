require_relative 'instance'

# DPLL SAT solver.
class Solver
  def solve(instance)
    @instance = instance
    @max = 2**instance.var_count
    @solution = 0
    @solved = false
    try(@solution, 1) unless try(@solution + 1, 1)
    @instance.solved
  end

  def try(solution, power)
    #p 'trying solution ' + solution.to_s + " / " + power.to_s + " / " + @max.to_s
    return false if solution >= @max
    #p 'after first return ' + solution.to_s + " / " + power.to_s + " / " + @max.to_s
    e = @instance.evaluate_solution(solution, power)
    #p 'evaluation = ' + e.to_s
    return false if e == -1
    #p 'after second return ' + solution.to_s + " / " + power.to_s + " / " + @max.to_s
    #p 'instance size = ' + @instance.size.to_s
    return true if e == @instance.size
    #p 'after third return ' + solution.to_s + " / " + power.to_s + " / " + @max.to_s
    r = try(solution + 2**power, power + 1)
    #p 'result = ' + r.to_s
    return true if r
    #p 'after fourth return ' + solution.to_s + " / " + power.to_s + " / " + @max.to_s
    try(solution, power + 1)
  end
end
