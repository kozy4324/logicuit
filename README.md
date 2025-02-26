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
require "logicuit"

# 1 bit CPU
#
#  +-(Y)-|NOT|-(A)-+
#  |               |
#  +-(D)-|   |-(Q)-+
#        |DFF|
#   (CK)-|>  |
#
class OneBitCpu
  def initialize
    @dff = Logicuit::Circuits::Sequential::DFlipFlop.new
    @not = Logicuit::Gates::Not.new
    @dff.q >> @not.a
    @not.y >> @dff.d
  end

  def to_s
    <<~CIRCUIT
      +-(#{@not.y})-|NOT|-(#{@not.a})-+
      |               |
      +-(#{@dff.d})-|   |-(#{@dff.q})-+
            |DFF|
       (CK)-|>  |
    CIRCUIT
  end
end

obc = OneBitCpu.new
loop do
  system("clear")
  puts obc
  sleep 1
  Logicuit::Signals::Clock.tick
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kozy4324/logicuit.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
