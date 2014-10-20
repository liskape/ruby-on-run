# RubyOnRun

Ruby on Run is program that interprets bytecode from rubinius compiler

## Development

Unit tests:

    $ rspec
    $ rspec spec

Integration tests (TODO):

    $ rake test:functions
    $ rake test:recursion
    $ rake test:class
    $ ...
    $ rake test:all


## Execeution

Interpret bytecode from file or stream

    $ bin/ruby_on_run file.bytecode

Compile ruby file using rubinius and interpret

    $ bin/ruby file.rb
