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
        # Call the `evaluate` method for all components.
        # However, the input argument values should be bound to the values at the time `on_tick` is called.
        @on_tick.map do |component|
          args = component.input_targets.map { |input| component.instance_variable_get("@#{input}").current }
          -> { component.evaluate(*args) }
        end.each(&:call)
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
