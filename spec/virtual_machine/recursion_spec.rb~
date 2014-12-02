describe RubyOnRun::VirtualMachine do

  context 'recursion' do

    let(:file){ File.expand_path("../bytecode_samples/highly_recursive_class.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    specify do
      pending
      expect(STDOUT).to receive(:puts).with(15)
      expect(STDOUT).to receive(:puts).with(9)
      RubyOnRun::VirtualMachine.new(stream).run
    end
  end

end
