describe RubyOnRun::Bytecode do

  context 'expression only' do
    let(:stream) { File.open('spec/bytecode_samples/sample1.bytecode').read }
    let(:bytecode) { RubyOnRun::Bytecode.load(stream) }
    let(:bytecode_data) { RubyOnRun::Bytecode.load(stream).body }

    it 'has magic number' do
      expect(bytecode.magic).to eq "!RBIX"
    end

    it 'has signature' do
      expect(bytecode.signature).to eq 11376054418551619337
    end

    it 'has version' do
      expect(bytecode.version).to eq 22
    end

    describe do
      {
        metadata: nil,
        primitive: nil,
        name: :'__script__',
        iseq: [4, 3, 80, 50, 0, 1, 15, 2, 11],
        stack_size: 2,
        local_count: 0,
        required_args: 0,
        post_args: 0,
        total_args: 0,
        splat: nil,
        literals: [:+],
        lines: [0, 1, 9],
        file: :'expr1.rb',
        local_names: [],
      }.each do |key, value|
          it "#{key}" do expect(bytecode_data.send key).to eq(value) end
        end
    end
  end

  context 'expression and local variables' do
    let(:stream) { File.open('spec/bytecode_samples/expr2.bytecode').read }
    let(:bytecode) { RubyOnRun::Bytecode.load(stream) }
    let(:bytecode_data) { RubyOnRun::Bytecode.load(stream).body }

    it 'has magic number' do
      expect(bytecode.magic).to eq "!RBIX"
    end

    it 'has signature' do
      expect(bytecode.signature).to eq 11376054418551619337
    end

    it 'has version' do
      expect(bytecode.version).to eq 22
    end

    describe do
      {
        metadata: nil,
        primitive: nil,
        name: :'__script__',
        iseq: [4, 8, 19, 0, 15, 20, 0, 4, 5, 50, 0, 1, 15, 2, 11],
        stack_size: 3,
        local_count: 1,
        required_args: 0,
        post_args: 0,
        total_args: 0,
        splat: nil,
        literals: [:-],
        lines: [0, 1, 5, 2, 15],
        file: :'expr2.rb',
        local_names: [:var],
      }.each do |key, value|
          it "attribute: #{key}" do expect(bytecode_data.send key).to eq(value) end
        end
    end
  end
end
