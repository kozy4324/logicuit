# frozen_string_literal: true

# rbs_inline: enabled

module Logicuit
  module Gates
    # AND gate
    class And < DSL
      diagram <<~DIAGRAM
        (A)-|   |
            |AND|-(Y)
        (B)-|   |
      DIAGRAM

      # @rbs! attr_reader a: Signals::Signal
      # @rbs! attr_reader b: Signals::Signal
      inputs :a, :b

      # @rbs! attr_reader y: Signals::Signal
      outputs y: ->(o) { o.a & o.b }

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
