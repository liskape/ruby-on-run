class NastyClass

  attr_reader :var1, :var2, :var3

  def initialize
    @var1 = 2
    @var2 = 12
    @var3 = 42
  end
end

nasty = NastyClass.new
puts nasty.var1 * nasty.var2 * nasty.var3
