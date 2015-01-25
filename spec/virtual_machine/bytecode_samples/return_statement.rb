class Dummy
  def some_method
    return 0 if true
    1
  end

  def another_method
    if true 
      return 0
    end
    1
  end

  def another_another_method
    if true then return 0 end
    1
  end
end


puts Dummy.new.some_method
puts Dummy.new.another_method
puts Dummy.new.another_another_method
