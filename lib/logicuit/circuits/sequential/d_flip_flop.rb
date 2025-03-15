# frozen_string_literal: true

module Logicuit
  module Circuits
    module Sequential
      # D Flip-Flop
      class DFlipFlop < Base
        diagram <<~DIAGRAM
          (D)--|   |--(Q)
               |DFF|
          (CK)-|>  |
        DIAGRAM

        define_inputs :d, clock: :ck

        define_outputs q: ->(d) { d }
      end
    end
  end
end
