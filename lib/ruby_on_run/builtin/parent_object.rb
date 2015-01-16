require_relative '../vm/class'

module RubyOnRun
  module Builtin

  # top class
  class ParentObject

    alias_method :original_method, :method 

    def initialize(vm, superklass)
      @vm = vm
      @superklass = superklass

      # should by Constant :Class <- but we dont have bootstrapped
      # we dont support so much reflection
      # classes Object and Class are closed
      # this way it searches here as it would in Class class, but ends here
      # super(self)
    end

      # usually C/C++ implementation
      def method(name)
        return NativeCompiledCode.new( original_method(:empty_method) ) if name == :initialize

        NativeCompiledCode.new(original_method(name))
      end

      def name
        :ParentObject
      end

      def require_relative(file)
        filename = "spec/virtual_machine/bytecode_samples/#{file}.bytecode"        
        @vm.interpret_file File.expand_path(filename)
      end

      def nil?
        false
      end

      def method_visibility
        #do nothing for now
      end

      def private
      end

      def empty_method(*args)
      end
    end
  end
end
