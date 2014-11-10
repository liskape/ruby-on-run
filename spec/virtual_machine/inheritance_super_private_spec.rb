describe RubyOnRun::VirtualMachine do

  context 'inheritance, super, private method' do

    let(:file){ File.expand_path("../bytecode_samples/buffer.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    pending
  end

end
