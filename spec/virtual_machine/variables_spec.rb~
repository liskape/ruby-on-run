describe RubyOnRun::VirtualMachine do

  context 'variables' do

    let(:file){ File.expand_path("../bytecode_samples/variables.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    specify 'program output 1000 via puts' do
      expect(STDOUT).to receive(:puts).with(1000)
      RubyOnRun::VirtualMachine.new(stream).run
    end
  end

end
