class RubyOnRun::RRange


  def initialize(left, right)
    @range = (left..right)
  end

  def self.allocate()
    range = Range.allocate

    def range.initialize(left, rigth)
      binding.pry
      (left..rigth)
    end

    range

  end
end
