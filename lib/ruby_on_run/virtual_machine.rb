# main class
class RubyOnRun::VirtualMachine

  include InstructionInterpretation

  DEBUG = true

  def initialize(stream)
    @code = RubyOnRun::Bytecode.load(stream).body # compiledCode
    # @vm_stack = RubyOnRun::Stack.new context
    @classes = {} # HEAP in the future
  end

  def run
    @main_context = MainContext.new
    interpret RubyOnRun::Context.new(@code, nil, @main_context, nil)
  end

  def interpret(context)
    while true
      instruction = context.next_instruction
      break if instruction.nil?
      instruction.print if DEBUG     
      send instruction.name, instruction.param_hash, context
      if DEBUG
        p 'top = ' + context.top.to_s 
        p 'locals = ' + context.locals.to_s
        p 'binding = ' + context.binding.to_s
        p '==========='
      end      
    end
    @return_value
  end

  def invoke

  end

  def open_class(class_name, dunno1, scope)
    @classes[class_name] ||= RubyOnRun::RClass.new(self)
    @classes[class_name]
  end

  def add_defn_method(method_name, compiled_code, scope, dunno)
    scope.define_method(method_name, compiled_code)
  end


  class MainContext # RClass

    attr_accessor :allow_private

    def initialize
      @allow_private = false
    end

    def Range
      RubyOnRun::RRange
    end 

    # def send(meth, *args, &block)
    #   raise "Method #{meth} is not implemented yet"
    # end 

end



end
