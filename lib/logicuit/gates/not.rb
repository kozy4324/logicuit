# frozen_string_literal: true

require_relative "base"

module Logicuit
  module Gates
    # NOT gate
    #
    # (A)-|NOT|-(Y)
    #
    class Not < Base
      def initialize(a = 0) # rubocop:disable Naming/MethodParameterName
        super()

        @a = Signals::Signal.new(a == 1)
        @a.on_change << self

        @y = Signals::Signal.new(false)
        evaluate
      end

      attr_reader :a, :y

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
