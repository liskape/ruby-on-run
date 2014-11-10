class RubyOnRun::Rubinius

  def send(*params)
    puts "Rubinius#send was called with #{params}"
  end
end
