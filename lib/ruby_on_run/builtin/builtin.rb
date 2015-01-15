# usually C/C++ code - different in invoking
# in ruby we can fetch method from class in system and interpret it as non-builtin
module RubyOnRun::Builtin
  module Builtin

    def klass
      nil
    end

    def get_singleton_method(name)
      RubyOnRun::Builtin::NativeCompiledCode.new method(name)
    end
  end
end
