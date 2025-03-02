# frozen_string_literal: true

require_relative "base"

module Logicuit
  module Gates
    # AND gate
    #
    # (A)-|
    #     |AND|-(Y)
    # (B)-|
    #
    class And < Base
      define_inputs :a, :b
      define_outputs y: ->(a, b) { a && b }

      def to_s
        <<~CIRCUIT
          (#{a})-|
              |AND|-(#{y})
          (#{b})-|
        CIRCUIT
      end
    end
  end
end
