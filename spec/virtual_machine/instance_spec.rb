describe RubyOnRun::VM::VirtualMachine do

  context 'instance spec' do

    let(:file){ File.expand_path("../bytecode_samples/instance_test.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }
    
    specify 'doesnt crash' do
      #expect(STDOUT).to receive(:puts).with(9)
      RubyOnRun::VM::VirtualMachine.new(stream).run
    end
  end

end
