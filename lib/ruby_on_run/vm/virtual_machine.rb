require_relative './object'

module RubyOnRun::VM
  class VirtualMachine

    include InstructionInterpretation

    DEBUG = false

    def initialize(stream)
      @code = RubyOnRun::VM::Bytecode.load(stream).body # compiledCode
      @classes = { Range: RubyOnRun::Builtin::RRange } # HEAP in the future
    end

    def compile_bultin_classes
       @classes[:ParentObject] = RubyOnRun::Builtin::Object.new
    end

    def run
      compile_bultin_classes
      main = MainContext.new(RubyOnRun::Builtin::Object.new)
      interpret RubyOnRun::VM::Context.new(@code, nil, main, nil, {})
    end

    def interpret(context)

      if context.compiled_code.is_a? RubyOnRun::Builtin::NativeCompiledCode
        native_code({}, context)
        ret({}, context)
        return @return_value
      end

      while true
        instruction = context.next_instruction
        break if instruction.nil?
        instruction.print if DEBUG
        send instruction.name, instruction.param_hash, context
        if DEBUG
          # p 'top = ' + context.top.to_s 
          # p 'locals = ' + context.locals.to_s
          # p 'binding = ' + context.binding.to_s
          # p '==========='
        end      
      end
      @return_value
    end
    
    def open_class(class_name, dunno1, scope)
      @classes[class_name] ||= RubyOnRun::VM::RClass.new(self)
      @classes[class_name]
    end

    def add_defn_method(method_name, compiled_code, scope, method_visibility)
      scope.define_method(method_name, compiled_code)
    end

    def attach_method(method_name, compiled_code, scope, _self)
      _self.add_singleton_method method_name, compiled_code
    end


    class MainContext < RubyOnRun::VM::RObject

      attr_accessor :allow_private

      # def Range
      #   RubyOnRun::Builtin::RRange
      # end 
    
    end
  end
end
