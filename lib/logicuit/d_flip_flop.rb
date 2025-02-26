# frozen_string_literal: true

module Logicuit
  # D Flip-Flop
  #
  # (D)--|   |--(Q)
  #      |DFF|
  # (CK)-|>  |
  #
  class DFlipFlop
    def initialize(d = 0) # rubocop:disable Naming/MethodParameterName
      Logicuit::Clock.on_tick << self

      @d = d.is_a?(Logicuit::Signal) ? d : Signal.new(d == 1)

      @q = Signal.new(false)
      evaluate
    end

    attr_reader :d, :q

    def evaluate
      if d.current
        q.on
      else
        q.off
      end
    end

    def to_s
      <<~CIRCUIT
        (#{d})--|   |--(#{q})
             |DFF|
        (CK)-|>  |
      CIRCUIT
    end
  end
end
