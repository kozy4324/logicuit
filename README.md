# Logicuit

logi(c cir)cuit -> logicuit

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add logicuit
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install logicuit
```

## Usage

This is the code to create a Multiplexer with 2 inputs and 1 output:

```
require 'logicuit'

class Multiplexer2to1 < Logicuit::Base
  diagram <<~DIAGRAM
    (C0)---------|
                 |AND|--+
         +-|NOT|-|      +--|
         |                 |OR|--(Y)
    (C1)---------|      +--|
         |       |AND|--+
    (A)--+-------|
  DIAGRAM

  define_inputs :c0, :c1, :a

  define_outputs y: ->(c0, c1, a) { (c0 && !a) || (c1 && a) }
end

Logicuit.run(:MY_MUX)
```

you can execute a same circuit by the following as a one-liner:

```
ruby -r ./lib/logicuit -e 'Logicuit.run(:mux)'
```

you can similarly execute other circuits with the following commands:

```
ruby -r ./lib/logicuit -e 'Logicuit.run(:dff)'
```

```
ruby -r ./lib/logicuit -e 'Logicuit.run(:one_bit_cpu)'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kozy4324/logicuit.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
