describe RubyOnRun::BytecodeParser do

  let(:stream) do
    <<-bytecode
!RBIX
11376054418551619337
22
M
1
n
n
x
E
8
US-ASCII
10
__script__
i
9
4
3
80
50
0
1
15
2
11
I
2
I
0
I
0
I
0
I
0
n
n
I
0
p
1
x
E
8
US-ASCII
1
+
p
3
I
0
I
1
I
9
x
E
8
US-ASCII
8
expr1.rb
p
0
bytecode
  end

  let(:parser) { RubyOnRun::BytecodeParser.load(stream) }

  describe '.instructions' do
    it "should return instruction sequence" do
      parser.body
    end
  end

end
