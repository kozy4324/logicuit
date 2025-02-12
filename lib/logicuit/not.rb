# frozen_string_literal: true

module Logicuit
  # NOT circuit
  #
  # A -|>o- Y
  #
  class Not
    def initialize(a) # rubocop:disable Naming/MethodParameterName
      @a = a.is_a?(Signal) ? a : Signal.new(a == 1)
      @y = Signal.new(@a.current.!)
    end

    attr_reader :a, :y
  end
end
