describe RubyOnRun::VM::VirtualMachine do

  context 'arrays' do

    let(:file){ File.expand_path("../bytecode_samples/array.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    specify 'return value is true' do
      machine = RubyOnRun::VM::VirtualMachine.new(stream)
      expect(machine.run).to eq true
    end
  end

  context 'array modification' do
    let(:file){ File.expand_path("../bytecode_samples/array_modification.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    specify 'program output 5 via puts' do
      expect(STDOUT).to receive(:puts).with(5)
      RubyOnRun::VM::VirtualMachine.new(stream).run
    end
  end

end
