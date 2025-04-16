# frozen_string_literal: true

module Logicuit
  module Signals
    # Signal
    class Signal
      def initialize(current = false)
        @current = current
        @downstreams = []
      end

      attr_reader :current

      def on
        return if @current

        @current = true
        propagate_current
      end

      def off
        return unless @current

        @current = false
        propagate_current
      end

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

      def to_s
        current ? "1" : "0"
      end

      private

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
