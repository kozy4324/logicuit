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

```
and_circuit = Logicuit::And.new(1, 1)
and_circuit.y.current # true: {a:1,b:1} => {y:1}

and_circuit.a.off
and_circuit.y.current # false: {a:0,b:1} => {y:0}

and_circuit.b.off
and_circuit.y.current # false: {a:0,b:0} => {y:0}

and_circuit.b.on
and_circuit.b.on
and_circuit.y.current # true: {a:1,b:1} => {y:1}
```

This is all for now :)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kozy4324/logicuit.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
