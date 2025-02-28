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
      define_outputs :y

      def evaluate
        a.current || b.current ? y.on : y.off
      end

      def to_s
        <<~CIRCUIT
          (#{a})-|
              |OR|-(#{y})
          (#{b})-|
        CIRCUIT
      end
    end
  end
end
