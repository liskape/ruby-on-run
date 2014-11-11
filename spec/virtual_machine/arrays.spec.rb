describe RubyOnRun::VirtualMachine do

  context 'arrays' do

    let(:file){ File.expand_path("../bytecode_samples/array.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    specify 'return value is true' do      
      machine = RubyOnRun::VirtualMachine.new(stream).run
      expect(machine.return_value).to eq true
    end
  end

end
