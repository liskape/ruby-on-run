describe RubyOnRun::VirtualMachine do

  context 'class methods' do

    let(:file){ File.expand_path("../bytecode_samples/class_methods.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }
    
    specify do
      pending
      expect(STDOUT).to receive(:puts).with(12)
      expect(STDOUT).to receive(:puts).with(13)
      expect(STDOUT).to receive(:puts).with(14)
      RubyOnRun::VirtualMachine.new(stream).run
    end
  end

end
