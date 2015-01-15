require_relative './object'
require_relative './virtual_machine_methods'

module RubyOnRun::VM
  class VirtualMachine

    include GeneralInstructionInterpretation
    include InvokeInstructionInterpretation
    include VirtualMachineMethods

    DEBUG = false

    def initialize(stream)
      fetch_builtin_classes
      fetch_standard_library #TODO: builtin classes use ony standard lib classes
      @code = RubyOnRun::VM::Bytecode.load(stream).body # compiledCode
    end

    def fetch_builtin_classes
      @classes = {}
      @classes[:Range] = RubyOnRun::Builtin::RRange
      @classes[:File] = RubyOnRun::Builtin::RFile
      @classes[:ParentObject] = RubyOnRun::Builtin::Object.new # default
    end

    def fetch_standard_library
      file =  File.expand_path('lib/ruby_on_run/stdlib/array.bytecode')
      stream =  File.open(file).read
      code = RubyOnRun::VM::Bytecode.load(stream).body
      main_wrapper = RubyOnRun::VM::RObject.new(RubyOnRun::Builtin::Object.new)
      interpret RubyOnRun::VM::Context.new(code, nil, main_wrapper, nil, {})
    end

    def run
      main_wrapper = RubyOnRun::VM::RObject.new(RubyOnRun::Builtin::Object.new)
      interpret RubyOnRun::VM::Context.new(@code, nil, main_wrapper, nil, {})
    end

    def classes
      @classes
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
  end
end
