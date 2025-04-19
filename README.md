# Logicuit

From logic circuit to Logicuit — a playful portmanteau.

A Ruby-based logic circuit simulator featuring an internal DSL for building circuits.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add logicuit
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install logicuit
```

## DSL

This library provides an internal DSL for defining logic circuits in a declarative and readable way.
You can define inputs, outputs, and even a visual diagram — all within a Ruby class.

Here is an example of a simple 2-input AND gate:

```
require "logicuit"

class MyAndGate < Logicuit::DSL
  inputs :a, :b

  outputs y: -> { a && b }

  diagram <<~DIAGRAM
    (A)-|   |
        |AND|-(Y)
    (B)-|   |
  DIAGRAM
end

MyAndGate.run
```

This defines:

- two inputs (`a` and `b`),
- one output (`y`) that returns the logical AND of the inputs,
- and an ASCII diagram that shows the structure of the gate.

### Interactive execution

When you call `run`, the simulator enters an interactive mode.

At first, the circuit is evaluated with all inputs set to `0`, and drawn as an ASCII diagram:

```
(0)-|   |
    |AND|-(0)
(0)-|   |

input: a,b?
```

To interact with the circuit, just type the name of an input — for example, `a` — and press Enter.
That input will toggle its value (`0 → 1` or `1 → 0`), and the diagram will be redrawn to reflect the new state.
You can keep toggling inputs this way to observe how the circuit reacts in real time.

To exit the simulator, simply press `Ctrl+C`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kozy4324/logicuit.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
