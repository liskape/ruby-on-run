class RubyOnRun::Scope

  def send(params)
    puts "Rubinius#send was called with #{params}"
  end

end
