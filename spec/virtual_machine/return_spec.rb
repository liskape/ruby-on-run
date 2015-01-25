describe RubyOnRun::VM::VirtualMachine do

  context 'closure spec' do

    let(:file){ File.expand_path("../bytecode_samples/return.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }
    
    specify 'receives puts with 0, 0, 0' do
      expect(STDOUT).to receive(:puts).with(0)
      expect(STDOUT).to receive(:puts).with(0)
      expect(STDOUT).to receive(:puts).with(0)

      RubyOnRun::VM::VirtualMachine.new(stream).run
    end
  end

end
