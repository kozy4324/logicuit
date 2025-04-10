# frozen_string_literal: true

module Logicuit
  module Signals
    # Signal
    class Signal
      def initialize(current = false) # rubocop:disable Style/OptionalBooleanParameter
        @current = current
        @connected_by = nil
        @downstreams = []
      end

      attr_reader :current, :downstreams
      attr_accessor :connected_by

      def on
        return if @current

        @current = true
        @downstreams.each(&:evaluate)
      end

      def off
        return unless @current

        @current = false
        @downstreams.each(&:evaluate)
      end

      def toggle
        @current ? off : on
      end

      def connects_to(other)
        other.connected_by = self
        other.evaluate
        downstreams << other
      end
      alias >> connects_to

      def evaluate
        return if @connected_by.nil?

        @connected_by.current ? on : off
      end

      def to_s
        current ? "1" : "0"
      end
    end
  end
end
