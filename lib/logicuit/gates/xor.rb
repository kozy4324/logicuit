# frozen_string_literal: true

module Logicuit
  module Gates
    # XOR gate
    class Xor < Base
      tag :XOR

      diagram <<~DIAGRAM
        (A)-|
            |XOR|-(Y)
        (B)-|
      DIAGRAM

      define_inputs :a, :b

      define_outputs y: ->(a, b) { (a && !b) || (!a && b) }

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
