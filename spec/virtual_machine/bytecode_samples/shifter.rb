class Shifter

  def initialize(wrapped)
    @wrapped = wrapped
  end

  def call
    @wrapped.shift
  end
end

s = Shifter.new [1, 2, 3]

puts s.call
puts s.call
puts s.call
