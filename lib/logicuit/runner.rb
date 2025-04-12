# frozen_string_literal: true

# Logicuit module
module Logicuit
  def self.run(sym, hz: 1, noclear: false)
    circuit = Base.registry[sym.upcase.to_sym].new

    render = lambda {
      system("clear") unless noclear
      puts circuit
      puts
      puts "tick: #{Signals::Clock.tick_count}" if circuit.clock
      if circuit.respond_to?(:instructions)
        puts "instructions: #{circuit.instructions.join "|"}"
      elsif circuit.input_targets.any?
        puts "input: #{circuit.input_targets.join ","}?"
      end
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

    while (input = gets.chomp)
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
