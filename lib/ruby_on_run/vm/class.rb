require_relative './object'
# require_relative '../builtin/object'

# structure that holds information about opened classes
# this class itself is RubyOnRun::VM::RObject 
# (has instance variables, singleton methods known as class methods)
module RubyOnRun::VM

  class RClass < RubyOnRun::VM::RObject

    alias_method :original_method, :method 
    attr_accessor :superklass, :name

    # needs vm reference for running bytecode of methods
    def initialize(allocator, name, superklass)
      @allocator = allocator
      @name = name
      @superklass = superklass || :ParentObject
      @method_table = { 
                        allocate: RubyOnRun::Builtin::NativeCompiledCode.new(original_method(:allocate))
                       }

      # should by Constant :Class <- but we dont have bootstrapped
      # we dont support so much reflection
      # classes Object and Class are closed
      # this way it searches here as it would in Class class, but ends here
      super(self)
    end

    def allocate
      RubyOnRun::VM::RObject.new(klass)
    end

    def define_method(name, code)
      @method_table[name] = code
    end

    def method(name)
      @method_table[name]
    end
  end
end
