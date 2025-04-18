# frozen_string_literal: true

module Logicuit
  module Gates
    # XOR gate
    class Xor < DSL
      diagram <<~DIAGRAM
        (A)-|   |
            |XOR|-(Y)
        (B)-|   |
      DIAGRAM

      inputs :a, :b

      outputs y: -> { (a && !b) || (!a && b) }

      truth_table <<~TRUTH_TABLE
        | A | B | Y |
        | - | - | - |
        | 0 | 0 | 0 |
        | 1 | 0 | 1 |
        | 0 | 1 | 1 |
        | 1 | 1 | 0 |
      TRUTH_TABLE
    end
  end
end
