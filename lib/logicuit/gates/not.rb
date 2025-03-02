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
      define_outputs y: ->(a) { !a } # rubocop:disable Style/SymbolProc

      def to_s
        <<~CIRCUIT
          (#{a})-|NOT|-(#{y})
        CIRCUIT
      end
    end
  end
end
