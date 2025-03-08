# frozen_string_literal: true

module Logicuit
  module Gates
    # AND gate
    class And < Base
      define_inputs :a, :b

      define_outputs y: ->(a, b) { a && b }

      diagram <<~DIAGRAM
        (A)-|
            |AND|-(Y)
        (B)-|
      DIAGRAM

      truth_table <<~TRUTH_TABLE
        | A | B | Y |
        | - | - | - |
        | 0 | 0 | 0 |
        | 1 | 0 | 0 |
        | 0 | 1 | 0 |
        | 1 | 1 | 1 |
      TRUTH_TABLE
    end
  end
end
