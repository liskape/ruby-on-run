describe RubyOnRun::VM::VirtualMachine do

  context 'instance variables' do

    let(:file){ File.expand_path("../bytecode_samples/scope.bytecode", __FILE__) }
    let(:stream){ File.open(file).read }
    
    pending

    # specify do
    #   expect(STDOUT).to receive(:puts).with(1, 1)

    #   expect(STDOUT).to receive(:puts).with(2, 2)

    #   expect(STDOUT).to receive(:puts).with(2, 2)

    #   expect(STDOUT).to receive(:puts).with(1, 1)

    #   expect(STDOUT).to receive(:puts).with(3, 3)

    #   expect(STDOUT).to receive(:puts).with(3, 3)

    #   expect(STDOUT).to receive(:puts).with(1, 1)

    #   expect(RubyOnRun::VM::VirtualMachine.new(stream).run).to eq true      
    # end
  end

end



# 1
# 1

# 2
# 2

# 2
# 2

# 1
# 1

# 3
# 3

# 3
# 3

# 1
# 1
