# frozen_string_literal: true

# rbs_inline: enabled

# Logicuit module
module Logicuit
  #: (DSL circuit, ?hz: ::Integer, ?noclear: bool) -> void
  def self.run(circuit, hz: 1, noclear: false)
    render = lambda {
      system("clear") unless noclear
      puts circuit
      puts
      puts "tick: #{Signals::Clock.tick_count}" if circuit.clock
      puts "input: #{circuit.input_targets.join ","}?" if circuit.input_targets.any?
    }

    if circuit.clock && hz.nonzero?
      Thread.new do
        loop do
          render.call
          sleep 1.0 / hz
          Signals::Clock.tick
        end
      end
    else
      render.call
    end

    while (input = gets&.chomp)
      key = input.to_sym
      unless circuit.respond_to? key
        if circuit.clock && hz.zero?
          Signals::Clock.tick
          render.call
        end
        next
      end

      signal = circuit.send(key)
      if signal.current
        signal.off
      else
        signal.on
      end
      render.call
    end
  end
end
