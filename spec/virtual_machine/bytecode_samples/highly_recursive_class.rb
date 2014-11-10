class HighlyRecursiveClasss
  
  def sum(ary)
    if ary.empty?
      0
    else
      ary.first + sum(ary[1..-1])
    end
  end

  def even_sum(ary)
    if ary.nil? || ary.empty?
      0
    else
      ary.first + do_nothing(ary[1..-1])
    end
  end

  def do_nothing(ary)
    even_sum ary[1..-1]
  end

end

rec = HighlyRecursiveClasss.new
puts rec.sum([1,2,3,4,5])
puts rec.even_sum([1,2,3,4,5])
