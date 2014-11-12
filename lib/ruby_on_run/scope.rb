class RubyOnRun::Scope

  def send(params)
    puts "SCOPE Rubinius#send was called with #{params}"
  end

end
