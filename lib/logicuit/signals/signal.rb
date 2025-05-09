# frozen_string_literal: true

# rbs_inline: enabled

module Logicuit
  module Signals
    # Signal
    class Signal
      # @rbs @downstreams: Array[Signal | DSL]

      #: (?bool current) -> void
      def initialize(current = false)
        @current = current
        @downstreams = []
      end

      attr_reader :current #: bool

      #: () -> void
      def on
        return if @current

        @current = true
        propagate_current
      end

      #: () -> void
      def off
        return unless @current

        @current = false
        propagate_current
      end

      #: (Signal | SignalGroup | Array[Signal] | DSL other) -> void
      def connects_to(other)
        if other.is_a? Array
          @downstreams.concat(other)
        elsif other.is_a? Signals::SignalGroup
          @downstreams.concat(other.signals)
        else
          @downstreams << other
        end
        propagate_current
      end
      alias >> connects_to

      #: () -> ("1" | "0")
      def to_s
        current ? "1" : "0"
      end

      # logical AND operation
      #: (Signal other) -> Signal
      def &(other)
        Signal.new(current && other.current)
      end

      # logical OR operation
      #: (Signal other) -> Signal
      def |(other)
        Signal.new(current || other.current)
      end

      # logical NOT operation
      #: () -> Signal
      def !
        Signal.new(!current)
      end

      private

      #: () -> void
      def propagate_current
        @downstreams.each do |downstream|
          if downstream.is_a?(Signal)
            current ? downstream.on : downstream.off
          elsif downstream.respond_to?(:evaluate)
            downstream.evaluate
          end
        end
      end
    end
  end
end
