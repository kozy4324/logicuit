# frozen_string_literal: true

module Logicuit
  # OR circuit
  #
  # (A)-|
  #     |OR|-(Y)
  # (B)-|
  #
  class Or
    def initialize(a, b) # rubocop:disable Naming/MethodParameterName
      @a = a.is_a?(Signal) ? a : Signal.new(a == 1)
      @a.on_change << self

      @b = b.is_a?(Signal) ? b : Signal.new(b == 1)
      @b.on_change << self

      @y = Signal.new(false)
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
