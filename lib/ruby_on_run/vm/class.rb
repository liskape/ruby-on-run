require_relative './object'
# require_relative '../builtin/object'
# structure that holds information about opened class
# this class itself is RubyOnRun::VM::RObject 
# (has instance variables, singleton methods known as class methods)
module RubyOnRun::VM

  class RClass < RubyOnRun::VM::RObject

    alias_method :original_method, :method 
    attr_accessor :superklass

    # needs vm reference for running bytecode of methods
    def initialize(vm, superklass = :ParentObject)
      @vm = vm
      @superklass = superklass
      @method_table = {}
      super(self) # why self? because fuck you, thats why
    end

    def new(*args)
      _allocate(self, *args)
    end

    def define_method(name, code)
      @method_table[name] = code
    end

    def method(name)
      @method_table[name] || native_method(name)
    end

    def native_method(name)
      RubyOnRun::Builtin::NativeCompiledCode.new original_method(name)

      rescue NameError
        nil
    end

    def method_visibility
    end

    private

    def _allocate(klass, *args)
      obj = RubyOnRun::VM::RObject.new(klass)

      # has initialize method that is dynamically added
      if klass.method(:initialize) && !klass.method(:initialize).is_a?(RubyOnRun::Builtin::NativeCompiledCode) 
        context = RubyOnRun::VM::Context.new(klass.method(:initialize), klass, obj, nil, {}) # PARENT CONTEXT IS NIL!!!
        context.add_binding create_binding(klass.method(:initialize).local_names, args)
        @vm.interpret context  # PARENT!!!
      end
      
      obj
    end

    def create_binding(keys, values)
      Hash[keys.zip(values)]
    end
  end
end
