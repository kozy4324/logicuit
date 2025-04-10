# frozen_string_literal: true

module Logicuit
  module Gates
    # NOT gate
    class Not < Base
      tag :NOT

      diagram <<~DIAGRAM
        (A)-|NOT|-(Y)
      DIAGRAM

      define_inputs :a

      define_outputs y: ->(a) { !a }

      truth_table <<~TRUTH_TABLE
        | A | Y |
        | - | - |
        | 0 | 1 |
        | 1 | 0 |
      TRUTH_TABLE
    end
  end
end
