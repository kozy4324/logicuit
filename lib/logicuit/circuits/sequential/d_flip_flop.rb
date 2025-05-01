# frozen_string_literal: true

module Logicuit
  module Circuits
    module Sequential
      # D Flip-Flop
      class DFlipFlop < DSL
        diagram <<~DIAGRAM
          (D)--|   |--(Q)
               |DFF|
          (CK)-|>  |
        DIAGRAM

        inputs :d, clock: :ck

        outputs q: ->(o) { o.d }

        truth_table <<~TRUTH_TABLE
          | CK | D | Q |
          | -- | - | - |
          |  ^ | 0 | 0 |
          |  ^ | 1 | 1 |
        TRUTH_TABLE
      end
    end
  end
end
