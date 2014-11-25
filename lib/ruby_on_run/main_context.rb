class RubyOnRun::MainContext

  attr_accessor :allow_private
  
  def initialize
    @@allow_private = false
  end

  def Range
    Range.new
  end   

  # def send(meth, *args, &block)
  #   raise "Method #{meth} is not implemented yet"
  # end	

end
