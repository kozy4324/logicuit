# frozen_string_literal: true

require_relative "base"

module Logicuit
  module Gates
    # OR gate
    #
    # (A)-|
    #     |OR|-(Y)
    # (B)-|
    #
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
