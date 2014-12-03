# structure that holds one instance
module RubyOnRun::VM
  class RObject

    attr_accessor :klass, :allow_private

    def initialize(klass)
      @klass = klass # was created by this class - place where lives instance methods
      @allow_private = false
      @singleton_methods = {} # implementation of eingenclass
      @instance_variables = {}
    end

    def set_instance_variable(name, value)
      @instance_variables[name] = value
    end

    def get_instance_variable(name)
      @instance_variables[name]
    end

    def add_singleton_method(name, code)
      @singleton_methods[name] = code
    end

    def get_singleton_method(name)
      @singleton_methods[name]
    end

    def private
    end
    
    @flags        # for GC
  end
end
