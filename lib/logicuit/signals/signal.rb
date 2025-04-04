# frozen_string_literal: true

module Logicuit
  module Signals
    # Signal
    class Signal
      def initialize(current = false) # rubocop:disable Style/OptionalBooleanParameter
        @current = current
        @connected_by = nil
        @on_change = []
      end

      attr_reader :current, :on_change
      attr_accessor :connected_by

      def on
        changed = @current.!
        @current = true
        @on_change.each(&:evaluate) if changed
        self
      end

      def off
        changed = @current
        @current = false
        @on_change.each(&:evaluate) if changed
        self
      end

      def toggle
        @current ? off : on
      end

      def connects_to(other)
        other.connected_by = self
        other.evaluate
        on_change << other
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
