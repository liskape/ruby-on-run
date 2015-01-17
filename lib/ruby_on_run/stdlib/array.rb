class Array

  def initialize
    @ary = []
  end

  def first
    @ary[0]
  end

  def [](elem)
    @ary[elem]
  end

  def <<(what)
    @ary << what
    self
  end

  def size
    @ary.size
  end
end
