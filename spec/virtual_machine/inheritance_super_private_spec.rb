describe RubyOnRun::VM::VirtualMachine do

  context 'inheritance, super, private method' do

    let(:file){ File.expand_path("../bytecode_samples/buffer.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    specify do
      expect(STDOUT).to receive(:puts).with(1)
      expect(STDOUT).to receive(:puts).with(3)
      expect(STDOUT).to receive(:puts).with(4)

      RubyOnRun::VM::VirtualMachine.new(stream).run
    end
  end

end
