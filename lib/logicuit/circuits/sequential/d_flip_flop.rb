# frozen_string_literal: true

module Logicuit
  module Circuits
    module Sequential
      # D Flip-Flop
      #
      # (D)--|   |--(Q)
      #      |DFF|
      # (CK)-|>  |
      #
      class DFlipFlop
        def initialize(d = 0) # rubocop:disable Naming/MethodParameterName
          Signals::Clock.on_tick << self

          @d = d.is_a?(Signals::Signal) ? d : Signals::Signal.new(d == 1)

          @q = Signals::Signal.new(false)
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
  end
end
