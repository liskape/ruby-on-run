describe RubyOnRun::InstructionSet do
  let(:stream) { [20, 1] }
  let(:instruction_set) { RubyOnRun::InstructionSet }
  let(:instruction) { instruction_set.parse_instruction(stream) }


  describe '#parse_instruction' do
    it "should return instruction push_local with local:1" do
      expect(instruction.name).to eq :push_local
    end
  end
end