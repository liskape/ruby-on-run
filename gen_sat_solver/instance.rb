# Represents SAT instance.
class Instance
  def initialize(formula, var_count)
    @formula = formula
	@var_count = var_count
    @best_satisfied_count = 0
  end

  def evaluate_solution(solution)
    satisfied = 0
    @formula.each do |x|
      satisfied += 1 if evaluate_clause(x, solution)
    end
    if satisfied > @best_satisfied_count
      @best_satisfied_count = satisfied
      @best_solution = solution
    end
    satisfied
  end

  def evaluate_clause(clause, solution)
    clause.each do |x|
      y = solution[x - 1] == 1
      return true if (x > 0 && y) || (x < 0 && !y)
    end
    false
  end

  attr_reader :best_solution, :best_satisfied_count, :var_count

  def size
    @formula.size
  end
end
