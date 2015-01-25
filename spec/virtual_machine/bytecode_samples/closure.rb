class Test

  def add(x)
    x + 1
  end

  def test
    a = 0
    b = [1, 2, 3]
    b.each do |x|
      a += add(x)
    end
    a
  end

end

t = Test.new
puts t.test
