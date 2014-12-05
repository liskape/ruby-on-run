# Represents SAT instance.
class Instance
  def initialize(formula, var_count)
    @formula = formula
    @var_count = var_count
    @solved = false
  end

  def evaluate_solution(solution, power)
    satisfied = 0
    @formula.each do |x|
      e = evaluate_clause(x, solution, power)
      return -1 if e == -1
      satisfied += 1 if e == 1
    end
    if satisfied == size
      @best_solution = solution
      @solved = true
    end
    satisfied
  end

  def evaluate_clause(clause, solution, power)
    im = true
    clause.each do |x|
      y = (solution >> (x.abs - 1)).odd?
      return 1 if (x > 0 && y) || (x < 0 && !y)
      im = false if x.abs > power
    end
    return -1 if im
    0
  end

  attr_reader :best_solution, :var_count, :solved

  def size
    @formula.size
  end
end
