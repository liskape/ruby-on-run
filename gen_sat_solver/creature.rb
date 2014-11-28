# Represents individual in genetic algorithm
class Creature
  attr_accessor :solution, :fitness

  def initialize(solution)
    @solution = solution
    @fitness = 0
  end
end
