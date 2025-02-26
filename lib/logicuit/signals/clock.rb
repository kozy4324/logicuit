# frozen_string_literal: true

module Logicuit
  module Signals
    # Clock
    class Clock
      def initialize
        @on_tick = []
      end

      attr_reader :on_tick

      def tick
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
    end
  end
end
