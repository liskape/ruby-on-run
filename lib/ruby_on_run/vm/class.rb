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

      # should by Constant :Class <- but we dont have bootstrapped
      # we dont support so much reflection
      # classes Object and Class are closed
      # this way it searches here as it would in Class class, but ends here
      super(self)
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

    # hack for method defined by class Class
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
      initialize_method = find_initialize(klass)
      if initialize_method
        context = RubyOnRun::VM::Context.new(initialize_method, klass, obj, nil, {}) # PARENT CONTEXT IS NIL!!!
        context.add_binding create_binding(initialize_method.local_names, args)
        @vm.interpret context  # PARENT!!!
      end

      obj
    end

    # TODO dry out with method lookup in invoke_instruction
    def find_initialize(klass)
      return false if klass.nil?
      initialize_method = klass.method(:initialize)
      
      if initialize_method.is_a?(RubyOnRun::Builtin::NativeCompiledCode)
        find_initialize(@vm.classes[klass.superklass])
      else
        initialize_method
      end
    end

    def create_binding(keys, values)
      Hash[keys.zip(values)]
    end
  end
end
