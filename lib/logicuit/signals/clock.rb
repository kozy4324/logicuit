# frozen_string_literal: true

module Logicuit
  module Signals
    # Clock
    class Clock
      def initialize
        @downstreams = []
        @tick_count = 0
      end

      attr_reader :downstreams, :tick_count

      def tick
        @tick_count += 1
        # Call the `evaluate` method for all components.
        # However, the input argument values should be bound to the values at the time `tick` is called.
        @downstreams.map do |component|
          args = component.input_targets.map { |input| component.instance_variable_get("@#{input}").current }
          -> { component.evaluate(*args) }
        end.each(&:call)
      end

      class << self
        def instance
          @instance ||= new
        end

        def connects_to(component)
          instance.downstreams << component
        end
        alias >> connects_to

        def tick
          instance.tick
        end

        def tick_count
          instance.tick_count
        end
      end
    end
  end
end
