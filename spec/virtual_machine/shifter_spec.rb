describe RubyOnRun::VirtualMachine do

  context 'instance variables' do

    let(:file){ File.expand_path("../bytecode_samples/shifter.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }
  
    specify do
      expect(STDOUT).to receive(:puts).with(1)
      expect(STDOUT).to receive(:puts).with(2)
      expect(STDOUT).to receive(:puts).with(3)
      expect(RubyOnRun::VirtualMachine.new(stream).run).to eq true      
    end
  end

end
