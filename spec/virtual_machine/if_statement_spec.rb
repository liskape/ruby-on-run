describe RubyOnRun::VM::VirtualMachine do

  context 'if statements with output' do

    let(:file){ File.expand_path("../bytecode_samples/if_statement_with_outputs.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    specify 'program output YES via puts' do
      expect(STDOUT).to receive(:puts).with('YES')
      RubyOnRun::VM::VirtualMachine.new(stream).run
    end
  end

end
