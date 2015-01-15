module RubyOnRun
  module Builtin
    class Object

      # usually C/C++ implementation
      def method(name)
        NativeCompiledCode.new(super)
      end

      def nil?
        false
      end
    end
  end
end
