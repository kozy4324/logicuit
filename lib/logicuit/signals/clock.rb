# frozen_string_literal: true

# rbs_inline: enabled

module Logicuit
  module Signals
    # Clock
    class Clock
      #: def initialize: () -> void
      def initialize
        #: @downstreams: Array[DSL]
        @downstreams = []
        #: @tick_count: Integer
        @tick_count = 0
      end

      # @rbs!
      #   attr_reader downstreams: Array[DSL]
      #   attr_reader tick_count: Integer
      attr_reader :downstreams, :tick_count

      #: def tick: () -> void
      def tick
        @tick_count += 1
        # Call the `evaluate` method for all components.
        # However, the input argument values should be bound to the values at the time `tick` is called.
        @downstreams.map do |component|
          args = component.input_targets.map { |input| Signal.new(component.send(input).current) }
          -> { component.evaluate(*args) }
        end.each(&:call)
      end

      class << self
        #: def self.instance: () -> Clock
        def instance
          #: self.@instance: Clock
          @instance ||= new
        end

        #: def self.connects_to: (DSL component) -> void
        def connects_to(component)
          instance.downstreams << component
        end
        alias >> connects_to

        #: def self.tick: () -> void
        def tick
          instance.tick
        end

        #: def self.tick_count: () -> Integer
        def tick_count
          instance.tick_count
        end
      end
    end
  end
end
