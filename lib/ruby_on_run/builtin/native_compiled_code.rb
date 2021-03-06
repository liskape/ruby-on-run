module RubyOnRun
  module Builtin
    class NativeCompiledCode < Struct.new(:method)

      def call(*args)
        method.call(*args)
      end

      def local_names
        # just enough, ideally something lazy (lazier than this)
        [:arg1, :arg2, :arg3, :arg4, :arg5]
      end

      def literals
      end

      def iseq
        [105, 11]
      end
    end
  end
end
