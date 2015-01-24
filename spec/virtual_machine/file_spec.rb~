describe RubyOnRun::VM::VirtualMachine do

  context 'file read and write' do

    let(:file){ File.expand_path("../bytecode_samples/file.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }
  
    specify 'program output 15 via puts' do
      pending
      expect(STDOUT).to receive(:puts).with(15)
      expect(RubyOnRun::VM::VirtualMachine.new(stream).run).to eq true      
    end
  end

end
