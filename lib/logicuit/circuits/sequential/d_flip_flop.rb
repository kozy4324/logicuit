# frozen_string_literal: true

# rbs_inline: enabled

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

        attr_reader :d, :q #: Signals::Signal

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
