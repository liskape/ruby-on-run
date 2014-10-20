describe RubyOnRun::Reader do

  let(:reader) { RubyOnRun::Reader.new }

  it "should return 6" do
    expect(reader.number).to eq 6
  end

  specify { expect(reader).to be_empty }

end