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
    # p 'trying solution ' + solution.to_s + " / " + power.to_s
    return false if solution >= @max
    e = @instance.evaluate_solution(solution, power)
    return false if e == -1
    return true if e == @instance.size
    r = try(solution + 2**power, power + 1)
    return true if r
    try(solution, power + 1)
  end
end
