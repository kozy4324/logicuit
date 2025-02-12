# frozen_string_literal: true

module Logicuit
  # Signal
  class Signal
    def initialize(current)
      @current = current
    end

    attr_reader :current
    attr_accessor :updater

    def on
      changed = @current.!
      @current = true
      @updater.call if changed && @updater.nil?.!
    end

    def off
      changed = @current
      @current = false
      @updater.call if changed && @updater.nil?.!
    end
  end
end
