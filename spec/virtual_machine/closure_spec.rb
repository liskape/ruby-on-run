describe RubyOnRun::VM::VirtualMachine do

  context 'closure spec' do

    let(:file){ File.expand_path("../bytecode_samples/closure.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }
    
    specify 'receives puts with 9' do
      expect(STDOUT).to receive(:puts).with(9)
      RubyOnRun::VM::VirtualMachine.new(stream).run
    end
  end

end
