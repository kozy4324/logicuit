# frozen_string_literal: true

module Logicuit
  module Gates
    # NOT gate
    class Not < Base
      define_inputs :a

      define_outputs y: ->(a) { !a } # rubocop:disable Style/SymbolProc

      diagram <<~DIAGRAM
        (A)-|NOT|-(Y)
      DIAGRAM

      truth_table <<~TRUTH_TABLE
        | A | Y |
        | - | - |
        | 0 | 1 |
        | 1 | 0 |
      TRUTH_TABLE
    end
  end
end
