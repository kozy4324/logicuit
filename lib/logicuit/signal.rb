# frozen_string_literal: true

module Logicuit
  # Signal
  class Signal
    def initialize(current)
      @current = current
      @on_change = []
    end

    attr_reader :current, :on_change

    def on
      changed = @current.!
      @current = true
      @on_change.each(&:evaluate) if changed
    end

    def off
      changed = @current
      @current = false
      @on_change.each(&:evaluate) if changed
    end

    def toggle
      @current ? off : on
    end

    def to_s
      current ? "1" : "0"
    end
  end
end
