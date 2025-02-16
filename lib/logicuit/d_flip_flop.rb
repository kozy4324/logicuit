# frozen_string_literal: true

module Logicuit
  # D Flip-Flop
  #
  # (D)--|   |--(Q)
  #      |DFF|
  # (CK)-|>  |
  #
  class DFlipFlop
    def initialize(d, ck) # rubocop:disable Naming/MethodParameterName
      @d = d.is_a?(Signal) ? d : Signal.new(d == 1)

      @ck = ck
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
