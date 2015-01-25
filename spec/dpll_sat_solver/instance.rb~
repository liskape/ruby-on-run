# Represents SAT instance.
class Instance
  def initialize(formula, var_count)
    @formula = formula
    @var_count = var_count
    @solved = false
  end

  def evaluate_solution(solution, power)
    satisfied = 0
    stop = false
    @formula.each do |x|
      if !stop
        e = evaluate_clause(x, solution, power)
        stop = true if e == -1
        satisfied += 1 if e == 1
      end
    end
    return -1 if stop
    if satisfied == size
      @best_solution = solution
      @solved = true
    end
    p 'evaluate returning ' + satisfied.to_s
    satisfied
  end

  def evaluate_clause(clause, solution, power)
    im = true
    stop = false
    clause.each do |x|
      if !stop
        y = (solution >> (x.abs - 1)).odd?
        stop = true if (x > 0 && y) || (x < 0 && !y)
        im = false if x.abs > power && !stop
      end
    end
    return 1 if stop
    return -1 if im
    0
  end

  def best_solution
    @best_solution
  end

  def var_count
    @var_count
  end

  def solved
    @solved
  end

  def size
    @formula.size
  end
end
