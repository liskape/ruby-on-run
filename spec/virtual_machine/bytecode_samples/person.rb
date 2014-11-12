class Person

  def initialize(first, last)
    @first_name, @last_name = first, last
  end

  def full_name
    @first_name + " " + @last_name
  end

end

p = Person.new("Adam", "Sandler")
puts p.full_name