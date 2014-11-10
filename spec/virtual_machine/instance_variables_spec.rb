describe RubyOnRun::VirtualMachine do

  context 'instance variables' do

    let(:file){ File.expand_path("../bytecode_samples/class_methods.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    pending
  end

end
