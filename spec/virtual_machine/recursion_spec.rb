describe RubyOnRun::VirtualMachine do

  context 'recursion' do

    let(:file){ File.expand_path("../bytecode_samples/highly_recursive_class.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    pending
  end

end
