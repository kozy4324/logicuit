# frozen_string_literal: true

# rbs_inline: enabled

module Logicuit
  module Circuits
    module Combinational
      # HalfAdder class
      class HalfAdder < DSL
        diagram <<~DIAGRAM
          (A)---+-|   |
                | |XOR|-(S)
          (B)-+---|   |
              | |
              | +-|   |
              |   |AND|-(C)
              +---|   |
        DIAGRAM

        attr_reader :a, :b, :c, :s #: Signals::Signal

        inputs :a, :b

        outputs :c, :s

        assembling do
          xor_gate = Gates::Xor.new
          and_gate = Gates::And.new

          a >> xor_gate.a
          b >> xor_gate.b
          xor_gate.y >> s

          a >> and_gate.a
          b >> and_gate.b
          and_gate.y >> c
        end

        truth_table <<~TRUTH_TABLE
          | A | B | C | S |
          | - | - | - | - |
          | 0 | 0 | 0 | 0 |
          | 0 | 1 | 0 | 1 |
          | 1 | 0 | 0 | 1 |
          | 1 | 1 | 1 | 0 |
        TRUTH_TABLE
      end
    end
  end
end
