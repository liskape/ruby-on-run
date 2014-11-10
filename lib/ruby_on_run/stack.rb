# class representing stack of whole VM
class RubyOnRun::Stack

  def initialize(main_frame)
    @stack_frames = [main_frame]
  end  
  
end
