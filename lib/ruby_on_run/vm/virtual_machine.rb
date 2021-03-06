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
      fetch_standard_library 
      @code = RubyOnRun::VM::Bytecode.load(stream).body # compiledCode
    end

    def fetch_builtin_classes
      @classes = {}
      @classes[:Range] = RubyOnRun::Builtin::RRange
      @classes[:File] = RubyOnRun::Builtin::RFile
      @classes[:ParentObject] = RubyOnRun::Builtin::ParentObject.new(self, nil) # default
    end

    def fetch_standard_library
      interpret_file File.expand_path('lib/ruby_on_run/stdlib/array.bytecode')
    end

    def run
      main_wrapper = RubyOnRun::VM::RObject.new(RubyOnRun::Builtin::ParentObject.new(self, nil))
      interpret RubyOnRun::VM::Context.new(@code, nil, main_wrapper, nil, {})
    end

    def classes
      @classes
    end

    def interpret_file(file)
      stream =  File.open(file).read
      code = RubyOnRun::VM::Bytecode.load(stream).body
      main_wrapper = RubyOnRun::VM::RObject.new(RubyOnRun::Builtin::ParentObject.new(self, nil))
      interpret RubyOnRun::VM::Context.new(code, nil, main_wrapper, nil, {})
    end

    def interpret(context)
      @continue ||= true

      while @continue
        instruction = context.next_instruction
        send instruction.name, instruction.param_hash, context
      end
      @continue = true
      @return_value
    end
  end
end
