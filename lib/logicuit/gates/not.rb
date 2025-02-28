# frozen_string_literal: true

require_relative "base"

module Logicuit
  module Gates
    # NOT gate
    #
    # (A)-|NOT|-(Y)
    #
    class Not < Base
      define_inputs :a
      define_outputs :y

      def evaluate
        a.current ? y.off : y.on
      end

      def to_s
        <<~CIRCUIT
          (#{a})-|NOT|-(#{y})
        CIRCUIT
      end
    end
  end
end
