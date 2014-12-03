require_relative './object'

module RubyOnRun::VM
  class VirtualMachine

    include GeneralInstructionInterpretation
    include InvokeInstructionInterpretation

    DEBUG = false

    def initialize(stream)
      @code = RubyOnRun::VM::Bytecode.load(stream).body # compiledCode
      @classes = { Range: RubyOnRun::Builtin::RRange } # HEAP in the future
      compile_bultin_classes
    end

    def compile_bultin_classes
       @classes[:ParentObject] = RubyOnRun::Builtin::Object.new
    end

    def run
      main = RubyOnRun::VM::RObject.new(RubyOnRun::Builtin::Object.new)
      interpret RubyOnRun::VM::Context.new(@code, nil, main, nil, {})
    end

    def interpret(context)

      while true
        instruction = context.next_instruction
        break if instruction.nil?
        instruction.print if DEBUG
        send instruction.name, instruction.param_hash, context
      end
     
      @return_value
    end
    
    def open_class(class_name, dunno1, scope)
      @classes[class_name] ||= RubyOnRun::VM::RClass.new(self)
    end

    def add_defn_method(method_name, compiled_code, scope, method_visibility)
      scope.define_method(method_name, compiled_code)
    end

    def attach_method(method_name, compiled_code, scope, _self)
      _self.add_singleton_method method_name, compiled_code
    end

  end
end
