# frozen_string_literal: true

module Logicuit
  module Gates
    # OR gate
    class Or < Base
      diagram <<~DIAGRAM
        (A)-|
            |OR|-(Y)
        (B)-|
      DIAGRAM

      define_inputs :a, :b

      define_outputs y: ->(a, b) { a || b }

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
