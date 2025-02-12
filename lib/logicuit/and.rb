# frozen_string_literal: true

module Logicuit
  # AND circuit
  #
  # A -+--
  #    |  )- Y
  # B -+--
  #
  class And
    def initialize(a, b) # rubocop:disable Naming/MethodParameterName
      @a = a.is_a?(Signal) ? a : Signal.new(a == 1)
      @b = b.is_a?(Signal) ? b : Signal.new(b == 1)
      @y = Signal.new(@a.current && @b.current)
    end

    attr_reader :a, :b, :y
  end
end
