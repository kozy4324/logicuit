# frozen_string_literal: true

module Logicuit
  # Signal
  class Signal
    def initialize(current)
      @current = current
    end

    attr_reader :current

    def on
      @current = true
    end

    def off
      @current = false
    end
  end
end
