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


puts some_method
puts another_method
puts another_another_method
