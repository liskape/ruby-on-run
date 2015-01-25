require_relative 'instance'

# Loads instances from files.
class Loader
  def self.load(file)
    a = []
    var_count = 0
    f = File.open(file, 'r')
    f.each_line do |line|
      t = line.split(" ")
      var_count = t[2].to_i if line.start_with? 'p'
      if !line.start_with?('p') && !line.start_with?('c')
        clause = []
        t.each { |x| clause << x.to_i if x.to_i != 0 }
        a << clause
      end
    end
    f.close
    Instance.new(a, var_count)
  end
end
