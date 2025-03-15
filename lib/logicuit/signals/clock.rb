# frozen_string_literal: true

module Logicuit
  module Signals
    # Clock
    class Clock
      def initialize
        @on_tick = []
        @tick_count = 0
      end

      attr_reader :on_tick, :tick_count

      def tick
        @tick_count += 1
        @on_tick.each(&:evaluate)
      end

      def self.instance
        @instance ||= new
      end

      def self.on_tick
        instance.on_tick
      end

      def self.tick
        instance.tick
      end

      def self.tick_count
        instance.tick_count
      end
    end
  end
end
