v = 1
@v = 1

puts v, @v

class MyClass
  v = 2
  @v = 2

  puts v, @v

  def my_method
    v = 3
    @v = 3
    puts v, @v
  end

  puts v, @v

end

puts v, @v

obj = MyClass.new
obj.my_method
obj.my_method

puts v, @v