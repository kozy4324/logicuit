# frozen_string_literal: true

module Logicuit
  module Circuits
    module Sequential
      # D Flip-Flop
      class DFlipFlop < Base
        tag :DFF

        diagram <<~DIAGRAM
          (D)--|   |--(Q)
               |DFF|
          (CK)-|>  |
        DIAGRAM

        define_inputs :d, clock: :ck

        define_outputs q: ->(d) { d }

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
