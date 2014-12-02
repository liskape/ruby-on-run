module RubyOnRun::Builtin
  class RRange

    def self.allocate()
      Range.allocate
    end
  end
end
