# frozen_string_literal: true

module Logicuit
  module Gates
    # AND gate
    #
    # (A)-|
    #     |AND|-(Y)
    # (B)-|
    #
    class And
      def initialize(a = 0, b = 0) # rubocop:disable Naming/MethodParameterName
        @a = Signals::Signal.new(a == 1)
        @a.on_change << self

        @b = Signals::Signal.new(b == 1)
        @b.on_change << self

        @y = Signals::Signal.new(false)
        evaluate
      end

      attr_reader :a, :b, :y

      def evaluate
        a.current && b.current ? y.on : y.off
      end

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
