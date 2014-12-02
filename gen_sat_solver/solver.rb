require_relative 'instance'
require_relative 'creature'

# SAT solver using genetic algorithm.
class Solver
  attr_accessor :formula_length, :pop_size, :gen_count

  MUT_CHANCE = 10

  def initialize(instance, pop_size, gen_count)
    @instance = instance
    @last_best = 0
    @var_count = instance.var_count
    @formula_length = instance.size
    @pop_size = pop_size
    @gen_count = gen_count
    @creatures = []
    @pop_size.times { @creatures << generate_creature }
    evaluate_creatures
    # print_creatures
  end

  def solve
    # p @instance.best_satisfied_count.to_s + "/" + @formula_length.to_s
    i = 0
    @gen_count.times do
      if @instance.best_satisfied_count < @formula_length
        iterate
        i += 1
      end
    end
    p i.to_s + ' iterations.'
    # print_creatures
    @instance.best_solution
  end

  def random_solve
    i = 0
    @gen_count.times do
      if @instance.best_satisfied_count < @formula_length
        @creatures = []
        @pop_size.times { @creatures << generate_creature }
        evaluate_creatures
        i += 1
      end
    end
    p i.to_s + ' random iterations.'
    # print_creatures
    p 'Random best: ' + @instance.best_satisfied_count.to_s + '/' + @formula_length.to_s
    @instance.best_solution
  end

  def evaluate_creatures
    @creatures.each { |c| c.fitness = @instance.evaluate_solution(c.solution) }
  end

  def print_creatures
    @creatures.each { |c| p c.solution.to_s + ' - ' + c.fitness.to_s + '/' + @formula_length.to_s }
  end

  def generate_creature
    c = []
    @var_count.times { c << rand(0..1) }
    Creature.new(c)
  end

  def iterate
    @creatures = @creatures.sort_by(&:fitness).reverse    
    breed(part_selection(@creatures, 4), 2)
    mutate(@creatures)
    evaluate_creatures
    p 'Best: ' + @instance.best_satisfied_count.to_s + '/' + @formula_length.to_s if @instance.best_satisfied_count > @last_best
    @last_best = @instance.best_satisfied_count
  end
  
  def part_selection(creatures, divider)
    selected = []
    for i in 0..(@pop_size / divider) - 1
      selected << @creatures[i]
    end
	selected
  end

  def breed(selected, multiplier)
    @creatures = []
	multiplier.times do
		for i in 0..selected.size - 1
		  a = rand(0..selected.size - 1)
		  a = (a + 1) % selected.size if a == i 
		  @creatures << Creature.new(combine(selected[a].solution, selected[i].solution, rand(0..@var_count)))
		end 
    end	
  end

  def mutate(creatures)
    creatures.each do |c|
      next if rand(0..99) <= MUT_CHANCE
      (c.solution.size / 10).times do
        r = rand(0..c.solution.size - 1)
        c.solution[r] = (c.solution[r] + 1) % 2
      end
    end
  end

  def combine(first, second, split)
    c = []
    for i in 0..@var_count - 1
      c << (i < split ? first[i] : second[i])
    end
    c
  end
end
