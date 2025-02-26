# frozen_string_literal: true

module Logicuit
  module Gates
    # OR gate
    #
    # (A)-|
    #     |OR|-(Y)
    # (B)-|
    #
    class Or
      def initialize(a = 0, b = 0) # rubocop:disable Naming/MethodParameterName
        @a = a.is_a?(Logicuit::Signals::Signal) ? a : Logicuit::Signals::Signal.new(a == 1)
        @a.on_change << self

        @b = b.is_a?(Logicuit::Signals::Signal) ? b : Logicuit::Signals::Signal.new(b == 1)
        @b.on_change << self

        @y = Logicuit::Signals::Signal.new(false)
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
