# Logicuit

```
                *******       *******       *******
               *********     *********     *********
              ***********   ***********   ***********
               *********     *********     *********
                *******       *******       *******

+-----------------------------------------------+       OUT 0111
|                                               |       ADD A,0001
+--->|rg_a|(0111)----->|   |                    |       JNC 0001
|    |1000|            |   |                    |       ADD A,0001
|                      |   |                    |     > JNC 0011
+--->|rg_b|(0000)----->|   |----------->|   |---+       OUT 0110
|    |0000|            |   |            |   |           ADD A,0001
|                      |SEL|            |ALU|           JNC 0110
+--->| out|  |  in|--->|   |            |   |           ADD A,0001
|    |0111|  |0000|    |   |  |  im|--->|   |--(0)      JNC 1000
|                      |   |  |0011|                    OUT 0000
+--->|  pc|  (0000)--->|   |                            OUT 0100
     |0100|                                             ADD A,0001
                                                        JNC 1010
                                                        OUT 1000
                                                        JMP 1111

tick: 48
input: in0,in1,in2,in3?
```

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

### Sequential circuits

In addition to combinational circuits, Logicuit also supports sequential circuits — circuits whose output depends not only on the current inputs, but also on past inputs.

For example, here’s a D flip-flop:

```
require "logicuit"

class MyDFlipFlop < Logicuit::DSL
  inputs :d, clock: :ck

  outputs q: -> { d }

  diagram <<~DIAGRAM
    (D)--|   |--(Q)
         |DFF|
    (CK)-|>  |
  DIAGRAM
end

MyDFlipFlop.run
```

#### Defining a sequential circuit

A circuit becomes sequential when the `inputs` declaration includes a keyword argument named `clock:`.
You can assign any name to the clock signal — in the above example, it's `:ck` — but the presence of the `clock:` keyword is what tells Logicuit to treat the circuit as sequential.

Once a clock is defined:

- The `outputs` lambdas will be evaluated on each clock tick, not continuously.
- A global singleton clock will drive the timing — you don’t need to define or manage the clock yourself.

#### Interactive execution with a clock

When a sequential circuit is run interactively, Logicuit enters clock mode. The clock ticks periodically, and the circuit is redrawn after each tick.

```
(0)--|   |--(0)
     |DFF|
(CK)-|>  |

tick: 2
input: d?
```

You can still toggle inputs as before (e.g., type `d` and press Enter), but updates take effect on the next tick.

The number of elapsed ticks is shown as `tick: N`.

#### Clock speed

By default, the clock ticks at 1 Hz (once per second). You can change the frequency by passing the `hz:` option to `run`:

```
MyDFlipFlop.run(hz: 10)
```

This will run the clock at 10 ticks per second — useful when simulating more complex circuits.

If you want full control, you can set `hz: 0` to disable automatic ticking.

In this mode, the clock only ticks when you press Enter, allowing you to step through the simulation manually:

```
MyDFlipFlop.run(hz: 0)
```

This is useful for debugging or analyzing a circuit’s behavior step by step.

#### Combining sequential circuits with `assembling`

You can build sequential circuits out of smaller components using the `assembling` block, just like with combinational circuits.

Here’s an example of a 4-bit register that stores its input when the load signal `ld` is not active:

```
require "logicuit"

class MyRegister4bit < Logicuit::DSL
  inputs :a, :b, :c, :d, :ld, clock: :ck

  outputs :qa, :qb, :qc, :qd

  assembling do
    [[a, qa], [b, qb], [c, qc], [d, qd]].each do |input, output|
      dff = Logicuit::Circuits::Sequential::DFlipFlop.new
      mux = Logicuit::Circuits::Combinational::Multiplexer2to1.new
      input >> mux.c0
      dff.q >> mux.c1
      ld    >> mux.a
      mux.y >> dff.d
      dff.q >> output
    end
  end

  diagram <<~DIAGRAM
            +---------------------+
            +-|   |               |
    (A)-------|MUX|-------|DFF|---+---(QA)
          +---|   |   +---|   |
          |           |
          | +---------------------+
          | +-|   |   |           |
    (B)-------|MUX|-------|DFF|---+---(QB)
          +---|   |   +---|   |
          |           |
          | +---------------------+
          | +-|   |   |           |
    (C)-------|MUX|-------|DFF|---+---(QC)
          +---|   |   +---|   |
          |           |
          | +---------------------+
          | +-|   |   |           |
    (D)-------|MUX|-------|DFF|---+---(QD)
          +---|   |   +---|   |
    (LD)--+     (CK)--+
  DIAGRAM
end

MyRegister4bit.run
```

#### Sequential detection

If your circuit contains one or more sequential components (such as D flip-flops), Logicuit will treat the entire circuit as sequential, as long as you declare a clock input using the `clock:` keyword in `inputs`.

The clock signal is automatically connected to all internal sequential components. You don't need to wire it manually — just declare it at the top level:

```
inputs ..., clock: :ck
```

> Note: If you forget to declare a clock input, Logicuit won't know it's a sequential circuit — even if you include flip-flops internally. Always include `clock:` to enable timing.

### Demo: Ramen Timer

Logicuit comes with a simple demo circuit — a working 4-bit CPU based on the TD4 architecture described in the book [CPUの創りかた](https://www.amazon.co.jp/dp/4839909865).

You can try it out by running:

```
ruby -r logicuit -e 'Logicuit::Circuits::Td4::Cpu.run'
```

This launches a fully functional CPU simulation that counts down from a programmed value — perfect for timing your instant ramen 🍜

The TD4 CPU is built entirely from logic gates and flip-flops, assembled using Logicuit’s DSL. It’s a great demonstration of how small components can be combined to create a complete digital system.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kozy4324/logicuit.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
