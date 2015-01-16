describe RubyOnRun::VM::VirtualMachine do

  context 'sat solver spec' do

    let(:file){ File.expand_path("../bytecode_samples/sat.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    
    specify do
      expect(STDOUT).to receive(:puts).with(true)
      RubyOnRun::VM::VirtualMachine.new(stream).run
    end
  end

end
