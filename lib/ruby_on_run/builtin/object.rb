module RubyOnRun
  module Builtin

    # top class for instance
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
