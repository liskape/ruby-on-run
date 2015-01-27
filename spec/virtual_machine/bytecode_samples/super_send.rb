class A

  def foo
    puts "foo"
    bar
  end

  def bar
    puts "bar1"
  end

end


class B < A

  def foo
    super
  end

  def bar
    puts "bar2"
  end

end


B.new.foo
