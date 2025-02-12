# frozen_string_literal: true

module Logicuit
  # NOT circuit
  #
  # A -|>o- Y
  #
  class Not
    def initialize(a) # rubocop:disable Naming/MethodParameterName
      updater = -> { @a.current ? @y.off : @y.on }

      @a = a.is_a?(Signal) ? a : Signal.new(a == 1)
      @a.updater = updater

      @y = Signal.new(false)
      updater.call
    end

    attr_reader :a, :y
  end
end
