# frozen_string_literal: true

module Logicuit
  module Gates
    # NOT gate
    #
    # (A)-|NOT|-(Y)
    #
    class Not
      def initialize(a = 0) # rubocop:disable Naming/MethodParameterName
        @a = a.is_a?(Signals::Signal) ? a : Signals::Signal.new(a == 1)
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
