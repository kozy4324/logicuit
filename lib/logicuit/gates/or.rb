# frozen_string_literal: true

# rbs_inline: enabled

module Logicuit
  module Gates
    # OR gate
    class Or < DSL
      diagram <<~DIAGRAM
        (A)-|  |
            |OR|-(Y)
        (B)-|  |
      DIAGRAM

      attr_reader :a, :b, :y #: Signals::Signal

      inputs :a, :b

      outputs y: ->(o) { o.a | o.b }

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
