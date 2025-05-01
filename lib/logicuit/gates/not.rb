# frozen_string_literal: true

module Logicuit
  module Gates
    # NOT gate
    class Not < DSL
      diagram <<~DIAGRAM
        (A)-|NOT|-(Y)
      DIAGRAM

      inputs :a

      outputs y: ->(o) { !o.a }

      truth_table <<~TRUTH_TABLE
        | A | Y |
        | - | - |
        | 0 | 1 |
        | 1 | 0 |
      TRUTH_TABLE
    end
  end
end
