# frozen_string_literal: true

module Logicuit
  module Gates
    # OR gate
    class Or < Base
      define_inputs :a, :b

      define_outputs y: ->(a, b) { a || b }

      diagram <<~DIAGRAM
        (A)-|
            |OR|-(Y)
        (B)-|
      DIAGRAM
    end
  end
end
