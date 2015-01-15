describe RubyOnRun::VM::VirtualMachine do

  context 'require' do
    let(:file){ File.expand_path("../bytecode_samples/require.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    specify 'program requires another class and calls it' do
      expect(STDOUT).to receive(:puts).with(314.0)
      RubyOnRun::VM::VirtualMachine.new(stream).run
    end
  end

end
