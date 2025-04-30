# frozen_string_literal: true

module Logicuit
  module Gates
    # AND gate
    class And < DSL
      diagram <<~DIAGRAM
        (A)-|   |
            |AND|-(Y)
        (B)-|   |
      DIAGRAM

      inputs :a, :b

      outputs y: ->(o) { o.a.current && o.b.current }

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
