class Buffer < Array

  def first
    super
  end
  
  def last
    self[size - 1]
  end

  def second
    get_element_at 2
  end

  private

  def get_element_at(position)
    self[position]
  end 

end


b = Buffer.new
b << 1 << 2 << 3 << 4
puts b.first
puts b.second
puts b.last

