describe RubyOnRun::VM::VirtualMachine do

  context 'class methods' do

    let(:file){ File.expand_path("../bytecode_samples/class_methods.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }
    
    specify do
      expect(STDOUT).to receive(:puts).with(12)
      expect(STDOUT).to receive(:puts).with(13)
      expect(STDOUT).to receive(:puts).with(14)
      RubyOnRun::VM::VirtualMachine.new(stream).run
    end
  end

end
