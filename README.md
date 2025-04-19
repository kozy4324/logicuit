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

### Assembling circuits

In addition to defining simple gates declaratively, Logicuit also lets you assemble circuits from reusable components using the `assembling` block.

This approach gives you more control and expressiveness when building complex circuits.

Here's an example of a 2-to-1 multiplexer:

```
require "logicuit"

class MyMultiplexer < Logicuit::DSL
  inputs :c0, :c1, :a

  outputs :y

  assembling do
    and_gate1 = Logicuit::Gates::And.new
    and_gate2 = Logicuit::Gates::And.new
    not_gate = Logicuit::Gates::Not.new
    or_gate = Logicuit::Gates::Or.new

    c0 >> and_gate1.a
    a >> not_gate.a
    not_gate.y >> and_gate1.b

    c1 >> and_gate2.a
    a >> and_gate2.b

    and_gate1.y >> or_gate.a
    and_gate2.y >> or_gate.b
    or_gate.y >> y
  end

  diagram <<~DIAGRAM
    (C0)---------|   |
                 |AND|--+
         +-|NOT|-|   |  +--|  |
         |                 |OR|--(Y)
    (C1)---------|   |  +--|  |
         |       |AND|--+
    (A)--+-------|   |
  DIAGRAM
end

MyMultiplexer.run
```

### Connection syntax

The `>>` operator is used to connect outputs to inputs, mimicking the direction of signal flow.

This allows the code to resemble the actual structure of the circuit, making it more intuitive to follow.

For example:

```
a >> not_gate.a
not_gate.y >> and_gate1.b
```

can be read as:

*"Connect input `a` to the NOT gate's input. Then connect the NOT gate's output to one of the AND gate's inputs."*

### Built-in gates

Logicuit includes several built-in logic gates, which you can use as components:

- `Logicuit::Gates::And`
- `Logicuit::Gates::Or`
- `Logicuit::Gates::Not`
- `Logicuit::Gates::Nand`
- `Logicuit::Gates::Xor`

These gates expose their input and output pins as attributes (`a`, `b`, `y`, etc.), which can be freely connected using `>>`.

### Signal groups

When building larger circuits, it's common to connect one output to multiple inputs, or to connect multiple outputs to multiple inputs.

Logicuit provides a convenient way to express these kinds of connections using signal groups.

#### One-to-many connections

These two lines:

```
a >> xor_gate.a
a >> and_gate.a
```

can be written more concisely as:

```
a >> [xor_gate.a, and_gate.a]
```

The array on the right-hand side is treated as a signal group, and the connection is applied to each element.

#### Many-to-many connections

You can also connect multiple outputs to multiple inputs at once by using the [] method to access signals by name:

```
pc.qa >> rom.a0
pc.qb >> rom.a1
pc.qc >> rom.a2
pc.qd >> rom.a3
```

is equivalent to:

```
pc[:qa, :qb, :qc, :qd] >> rom[:a0, :a1, :a2, :a3]
```

This `#[](*keys)` method returns a `SignalGroup` object — a Logicuit abstraction that makes it easier to handle groups of signals together.

> Note: The number of signals on both sides must match.

#### Connecting from different sources

What if you want to connect signals from multiple different components as a single group?

You can use `Logicuit::ArrayAsSignalGroup`, which adds signal group behavior to arrays:

```
using Logicuit::ArrayAsSignalGroup

assembling do
  [register_a.qa, register_b.qa, in0] >> mux0[:c0, :c1, :c2]
end
```

This lets you treat a plain Ruby array as a `SignalGroup` and connect it to another group of inputs in one line.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kozy4324/logicuit.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
