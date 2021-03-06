describe RubyOnRun::VM::VirtualMachine do

  context 'for loop' do

    let(:file){ File.expand_path("../bytecode_samples/for_loop.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }
  
    specify 'program output 6 via puts' do
      expect(STDOUT).to receive(:puts).with(6)
      expect(RubyOnRun::VM::VirtualMachine.new(stream).run).to eq true      
    end
  end

end
