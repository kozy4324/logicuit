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
      def initialize(a = 0, b = 0) # rubocop:disable Naming/MethodParameterName
        super()

        @a = Signals::Signal.new(a == 1)
        @a.on_change << self

        @b = Signals::Signal.new(b == 1)
        @b.on_change << self

        @y = Signals::Signal.new(false)
        evaluate
      end

      attr_reader :a, :b, :y

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
