# frozen_string_literal: true

module Logicuit
  # NOT circuit
  #
  # (A)-|NOT|-(Y)
  #
  class Not
    def initialize(a) # rubocop:disable Naming/MethodParameterName
      @a = a.is_a?(Signal) ? a : Signal.new(a == 1)
      @a.on_change << self

      @y = Signal.new(false)
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
