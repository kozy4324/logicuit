# frozen_string_literal: true

module Logicuit
  # D Flip-Flop
  #
  # (D)--|   |--(Q)
  #      |DFF|
  # (CK)-|>  |
  #
  class DFlipFlop
    def initialize(d = 0, ck = nil) # rubocop:disable Naming/MethodParameterName
      @d = d.is_a?(Logicuit::Signal) ? d : Signal.new(d == 1)

      @ck = ck.is_a?(Logicuit::Clock) ? ck : Logicuit::Clock.new
      @ck.on_tick << self

      @q = Signal.new(false)
      evaluate
    end

    attr_reader :d, :ck, :q

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
