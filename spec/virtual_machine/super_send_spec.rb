describe RubyOnRun::VM::VirtualMachine do

  context 'require' do
    let(:file){ File.expand_path("../bytecode_samples/super_send.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    specify 'program requires another class and calls it' do
      # expect(STDOUT).to receive(:puts).with("foo")
      # expect(STDOUT).to receive(:puts).with("bar2")

      RubyOnRun::VM::VirtualMachine.new(stream).run
    end
  end

end
