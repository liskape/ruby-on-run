require "ruby_on_run/version"

module RubyOnRun

  BASE_LIB_PATH = File.expand_path("..", __FILE__)

   # Load all constants.
  Dir["#{BASE_LIB_PATH}/ruby_on_run/*.rb"].sort.each do |f|
    require "ruby_on_run/#{File.basename(f, '.rb')}"
  end

  Dir["#{BASE_LIB_PATH}/ruby_on_run/vm/*.rb"].sort.each do |f|
    require "ruby_on_run/vm/#{File.basename(f, '.rb')}"
  end

  # compiling in future
  Dir["#{BASE_LIB_PATH}/ruby_on_run/builtin/*.rb"].sort.each do |f|
    require "ruby_on_run/builtin/#{File.basename(f, '.rb')}"
  end


  # just for now
  # in final version injecting file th params from CLI

#  stream = File.open('spec/bytecode_samples/if_statement.bytecode').read
end
