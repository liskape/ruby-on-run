describe RubyOnRun::VM::VirtualMachine do

  context 'instance variables' do

    let(:file){ File.expand_path("../bytecode_samples/person.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    
    specify do
      expect(STDOUT).to receive(:puts).with("Adam Sandler")
      RubyOnRun::VM::VirtualMachine.new(stream).run
    end
  end

end
