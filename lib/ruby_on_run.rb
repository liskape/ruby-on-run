require "ruby_on_run/version"

module RubyOnRun

  BASE_LIB_PATH = File.expand_path("..", __FILE__)

   # Load all constants.
  Dir["#{BASE_LIB_PATH}/ruby_on_run/*.rb"].sort.each do |f|
    require "ruby_on_run/#{File.basename(f, '.rb')}"
  end
end
