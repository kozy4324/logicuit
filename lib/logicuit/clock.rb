# frozen_string_literal: true

module Logicuit
  # Clock
  class Clock
    def initialize
      @on_tick = []
    end

    attr_reader :on_tick

    def tick
      @on_tick.each(&:evaluate)
    end
  end
end
