# frozen_string_literal: true

module Logicuit
  module Circuits
    module Combinational
      # FullAdder class
      class FullAdder < Base
        tag :FADD

        diagram <<~DIAGRAM
          (Cin)-|    |---(S)
          (A)---|FADD|
          (B)---|    |---(C)
        DIAGRAM

        define_inputs :cin, :a, :b

        define_outputs :c, :s

        truth_table <<~TRUTH_TABLE
          | Cin | A | B | C | S |
          | --- | - | - | - | - |
          |   0 | 0 | 0 | 0 | 0 |
          |   0 | 0 | 1 | 0 | 1 |
          |   0 | 1 | 0 | 0 | 1 |
          |   0 | 1 | 1 | 1 | 0 |
          |   1 | 0 | 0 | 0 | 1 |
          |   1 | 0 | 1 | 1 | 0 |
          |   1 | 1 | 0 | 1 | 0 |
          |   1 | 1 | 1 | 1 | 1 |
        TRUTH_TABLE
      end
    end
  end
end
