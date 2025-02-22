# frozen_string_literal: true

module Logicuit
  # Signal
  class Signal
    def initialize(current)
      @current = current
      @connected_to = nil
      @on_change = []
    end

    attr_reader :current, :on_change
    attr_accessor :connected_to

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

    def connects_to(other)
      other.connected_to = self
      other.evaluate
      on_change << other
    end
    alias >> connects_to

    def evaluate
      return if @connected_to.nil?

      @connected_to.current ? on : off
    end

    def to_s
      current ? "1" : "0"
    end
  end
end
