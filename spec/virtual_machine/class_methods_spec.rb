describe RubyOnRun::VirtualMachine do

  context 'class methods' do

    let(:file){ File.expand_path("../bytecode_samples/class_methods.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }

    pending
    
    # specify do
    #   RubyOnRun::VirtualMachine.new(stream).run

    # end
  end

end
