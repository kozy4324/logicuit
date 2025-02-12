# frozen_string_literal: true

module Logicuit
  # OR circuit
  #
  # A -+--
  #    )  )- Y
  # B -+--
  #
  class Or
    def initialize(a, b) # rubocop:disable Naming/MethodParameterName
      updater = -> { @a.current || @b.current ? @y.on : @y.off }

      @a = a.is_a?(Signal) ? a : Signal.new(a == 1)
      @a.updater = updater

      @b = b.is_a?(Signal) ? b : Signal.new(b == 1)
      @b.updater = updater

      @y = Signal.new(false)
      updater.call
    end

    attr_reader :a, :b, :y
  end
end
