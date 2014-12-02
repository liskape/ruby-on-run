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