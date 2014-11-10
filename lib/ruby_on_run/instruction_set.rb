require "pry"

# https://github.com/rubinius/rubinius-compiler/blob/2.0/lib/rubinius/compiler/opcodes.rb
module RubyOnRun
  class InstructionSet

    @opcodes = []

    def self.opcodes
      @opcodes
    end

    def self.create_instruction_class(options)
      Class.new.tap do |klass|
        klass.class_eval do

          %i(code name stack args control_flow).each do |meth|
            define_method meth do
              options[meth]
            end
          end

          options[:args].each do |meth|
            attr_accessor meth
          end

        end
      end
    end

    def self.opcode(code, name, options)
      @opcodes[code] = create_instruction_class options.merge(code: code, name: name)
    end

    # expects array of bytes
    # fetch code
    # fetch params if any
    # returns Instruction
    def self.parse_instruction(instruction_stream)
      opcodes[instruction_stream.shift].new.tap do |instruction|
        instruction.args.each do |arg|
          instruction.send "#{arg}=", instruction_stream.shift
        end
      end
    end

    opcode 0, :noop, :stack => [0, 0], :args => [], :control_flow => :next
    # Push primitive values
    opcode 1, :push_nil, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 2, :push_true, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 3, :push_false, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 4, :push_int, :stack => [0, 1], :args => [:number], :control_flow => :next
    opcode 5, :push_self, :stack => [0, 1], :args => [], :control_flow => :next
    # Manipulate literals
    opcode 6, :set_literal, :stack => [1, 1], :args => [:literal], :control_flow => :next
    opcode 7, :push_literal, :stack => [0, 1], :args => [:literal], :control_flow => :next
    # Flow control
    opcode 8, :goto, :stack => [0, 0], :args => [:location], :control_flow => :branch
    opcode 9, :goto_if_false, :stack => [1, 0], :args => [:location], :control_flow => :branch
    opcode 10, :goto_if_true, :stack => [1, 0], :args => [:location], :control_flow => :branch
    opcode 11, :ret, :stack => [1, 1], :args => [], :control_flow => :return
    # Stack manipulations
    opcode 12, :swap_stack, :stack => [2, 2], :args => [], :control_flow => :next
    opcode 13, :dup_top, :stack => [1, 2], :args => [], :control_flow => :next
    opcode 14, :dup_many, :stack => [[0,1], [0, 1, 2]],:args => [:count], :control_flow => :next
    opcode 15, :pop, :stack => [1, 0], :args => [], :control_flow => :next
    opcode 16, :pop_many, :stack => [[0,1], 0], :args => [:count], :control_flow => :next
    opcode 17, :rotate, :stack => [[0,1], [0, 1, 1]],:args => [:count], :control_flow => :next
    opcode 18, :move_down, :stack => [[0,1], [0, 1, 1]],:args => [:positions], :control_flow => :next
    # Manipulate local variables
    opcode 19, :set_local, :stack => [1, 1], :args => [:local], :control_flow => :next
    opcode 20, :push_local, :stack => [0, 1], :args => [:local], :control_flow => :next
    opcode 21, :push_local_depth, :stack => [0, 1], :args => [:depth, :index], :control_flow => :next
    opcode 22, :set_local_depth, :stack => [1, 1], :args => [:depth, :index], :control_flow => :next
    opcode 23, :passed_arg, :stack => [0, 1], :args => [:index], :control_flow => :next
    # Manipulate exceptions
    opcode 24, :push_current_exception, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 25, :clear_exception, :stack => [0, 0], :args => [], :control_flow => :next
    opcode 26, :push_exception_state, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 27, :restore_exception_state, :stack => [1, 0], :args => [], :control_flow => :next
    opcode 28, :raise_exc, :stack => [1, 0], :args => [], :control_flow => :raise
    opcode 29, :setup_unwind, :stack => [0, 0], :args => [:ip, :type], :control_flow => :handler
    opcode 30, :pop_unwind, :stack => [0, 0], :args => [], :control_flow => :next
    opcode 31, :raise_return, :stack => [1, 1], :args => [], :control_flow => :raise
    opcode 32, :ensure_return, :stack => [1, 1], :args => [], :control_flow => :raise
    opcode 33, :raise_break, :stack => [1, 1], :args => [], :control_flow => :raise
    opcode 34, :reraise, :stack => [0, 0], :args => [], :control_flow => :raise
    # Manipulate arrays
    opcode 35, :make_array, :stack => [[0,1], 1], :args => [:count], :control_flow => :next
    opcode 36, :cast_array, :stack => [1, 1], :args => [], :control_flow => :next
    opcode 37, :shift_array, :stack => [1, 2], :args => [], :control_flow => :next
    # Manipulate instance variables
    opcode 38, :set_ivar, :stack => [1, 1], :args => [:literal], :control_flow => :next
    opcode 39, :push_ivar, :stack => [0, 1], :args => [:literal], :control_flow => :next
    # Manipulate constants
    opcode 40, :push_const, :stack => [0, 1], :args => [:literal], :control_flow => :next
    opcode 41, :set_const, :stack => [1, 1], :args => [:literal], :control_flow => :next
    opcode 42, :set_const_at, :stack => [2, 1], :args => [:literal], :control_flow => :next
    opcode 43, :find_const, :stack => [1, 1], :args => [:literal], :control_flow => :next
    opcode 44, :push_cpath_top, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 45, :push_const_fast, :stack => [0, 1], :args => [:literal], :control_flow => :next
    opcode 46, :find_const_fast, :stack => [1, 1], :args => [:literal], :control_flow => :next
    # Send messages
    opcode 47, :set_call_flags, :stack => [0, 0], :args => [:flags], :control_flow => :next
    opcode 48, :allow_private, :stack => [0, 0], :args => [], :control_flow => :next
    opcode 49, :send_method, :stack => [1, 1], :args => [:literal], :control_flow => :send
    opcode 50, :send_stack, :stack => [[1,2], 1], :args => [:literal, :count], :control_flow => :send
    opcode 51, :send_stack_with_block, :stack => [[2,2], 1], :args => [:literal, :count], :control_flow => :send
    opcode 52, :send_stack_with_splat, :stack => [[3,2], 1], :args => [:literal, :count], :control_flow => :send
    opcode 53, :send_super_stack_with_block, :stack => [[1,2], 1], :args => [:literal, :count], :control_flow => :send
    opcode 54, :send_super_stack_with_splat, :stack => [[2,2], 1], :args => [:literal, :count], :control_flow => :send
    # Manipulate blocks
    opcode 55, :push_block, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 56, :passed_blockarg, :stack => [0, 1], :args => [:count], :control_flow => :next
    opcode 57, :create_block, :stack => [0, 1], :args => [:literal], :control_flow => :next
    opcode 58, :cast_for_single_block_arg, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 59, :cast_for_multi_block_arg, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 60, :cast_for_splat_block_arg, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 61, :yield_stack, :stack => [[0,1], 1], :args => [:count], :control_flow => :yield
    opcode 62, :yield_splat, :stack => [[1,1], 1], :args => [:count], :control_flow => :yield
    # Manipulate strings
    opcode 63, :string_append, :stack => [2, 1], :args => [], :control_flow => :next
    opcode 64, :string_build, :stack => [[0,1], 1], :args => [:count], :control_flow => :next
    opcode 65, :string_dup, :stack => [1, 1], :args => [], :control_flow => :next
    # Manipulate scope
    opcode 66, :push_scope, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 67, :add_scope, :stack => [1, 0], :args => [], :control_flow => :next
    opcode 68, :push_variables, :stack => [0, 1], :args => [], :control_flow => :next
    # Miscellaneous. TODO: better categorize these
    opcode 69, :check_interrupts, :stack => [0, 0], :args => [], :control_flow => :next
    opcode 70, :yield_debugger, :stack => [0, 0], :args => [], :control_flow => :next
    opcode 71, :is_nil, :stack => [1, 1], :args => [], :control_flow => :next
    opcode 72, :check_serial, :stack => [1, 1], :args => [:literal, :serial], :control_flow => :next
    opcode 73, :check_serial_private, :stack => [1, 1], :args => [:literal, :serial], :control_flow => :next
    # Access object fields
    opcode 74, :push_my_field, :stack => [0, 1], :args => [:index], :control_flow => :next
    opcode 75, :store_my_field, :stack => [1, 1], :args => [:index], :control_flow => :next
    # Type checks
    opcode 76, :kind_of, :stack => [2, 1], :args => [], :control_flow => :next
    opcode 77, :instance_of, :stack => [2, 1], :args => [], :control_flow => :next
    # Optimizations
    opcode 78, :meta_push_neg_1, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 79, :meta_push_0, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 80, :meta_push_1, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 81, :meta_push_2, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 82, :meta_send_op_plus, :stack => [2, 1], :args => [:literal], :control_flow => :send
    opcode 83, :meta_send_op_minus, :stack => [2, 1], :args => [:literal], :control_flow => :send
    opcode 84, :meta_send_op_equal, :stack => [2, 1], :args => [:literal], :control_flow => :send
    opcode 85, :meta_send_op_lt, :stack => [2, 1], :args => [:literal], :control_flow => :next
    opcode 86, :meta_send_op_gt, :stack => [2, 1], :args => [:literal], :control_flow => :next
    opcode 87, :meta_send_op_tequal, :stack => [2, 1], :args => [:literal], :control_flow => :send
    opcode 88, :meta_send_call, :stack => [[1,2], 1], :args => [:literal, :count], :control_flow => :send
    # More misc
    opcode 89, :push_my_offset, :stack => [0, 1], :args => [:index], :control_flow => :next
    opcode 90, :zsuper, :stack => [1, 1], :args => [:literal], :control_flow => :next
    opcode 91, :push_block_arg, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 92, :push_undef, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 93, :push_stack_local, :stack => [0, 1], :args => [:which], :control_flow => :next
    opcode 94, :set_stack_local, :stack => [1, 1], :args => [:which], :control_flow => :next
    opcode 95, :push_has_block, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 96, :push_proc, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 97, :check_frozen, :stack => [1, 1], :args => [], :control_flow => :next
    opcode 98, :cast_multi_value, :stack => [1, 1], :args => [], :control_flow => :next
    opcode 99, :invoke_primitive, :stack => [[0,2], 1], :args => [:literal, :count], :control_flow => :next
    opcode 100, :push_rubinius, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 101, :call_custom, :stack => [[1,2], 1], :args => [:literal, :count], :control_flow => :send
    opcode 102, :meta_to_s, :stack => [1, 1], :args => [:literal], :control_flow => :send
    opcode 103, :push_type, :stack => [0, 1], :args => [], :control_flow => :next
    opcode 104, :push_mirror, :stack => [0, 1], :args => [], :control_flow => :next
  end
end
