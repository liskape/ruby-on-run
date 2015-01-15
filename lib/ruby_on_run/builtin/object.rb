require_relative '../vm/class'

module RubyOnRun
  module Builtin

    # top class for instance
    class ParentObject < RubyOnRun::VM::RClass

      # usually C/C++ implementation
      def method(name)
        NativeCompiledCode.new(super)
      end

      def require_relative(file)
        filename = "spec/virtual_machine/bytecode_samples/#{file}.bytecode"        
        @vm.interpret_file File.expand_path(filename)
      end

      def nil?
        false
      end
    end
  end
end
