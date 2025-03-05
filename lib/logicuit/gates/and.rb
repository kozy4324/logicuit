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
    end
  end
end
