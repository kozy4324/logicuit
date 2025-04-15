# frozen_string_literal: true

module Logicuit
  module Gates
    # OR gate
    class Or < DSL
      diagram <<~DIAGRAM
        (A)-|
            |OR|-(Y)
        (B)-|
      DIAGRAM

      inputs :a, :b

      outputs y: ->(a, b) { a || b }

      truth_table <<~TRUTH_TABLE
        | A | B | Y |
        | - | - | - |
        | 0 | 0 | 0 |
        | 1 | 0 | 1 |
        | 0 | 1 | 1 |
        | 1 | 1 | 1 |
      TRUTH_TABLE
    end
  end
end
