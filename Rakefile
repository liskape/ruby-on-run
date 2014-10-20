require "bundler/gem_tasks"


desc "Open an irb session preloaded with this library"
task :console do
  sh "pry -r ./lib/ruby_on_run.rb"
end

task :c => :console


#######################################################################
# integration tests
# HERE definition of tasks:
# rake test:functions
# rake test:class
# rake test:dunno
# rake test:GC
# rake test:all

# loads predefined input (already compiled) and redirects it into our VM
# compare output
