File.write("files/file.txt", "1\n2\n3\n4\n5\n")
f = File.open("files/file.txt", "r")
s = 0
f.each_line do |line|
  s += line.to_i
end
puts s
