# frozen_string_literal: true

module Logicuit
  module Signals
    # Signal Group
    class SignalGroup
      def initialize(*signals)
        @signals = signals
      end

      def signals
        @signals.dup
      end

      def connects_to(others)
        others = others.signals if others.is_a?(self)
        @signals.zip(others).each do |signal, other|
          signal.connects_to(other) unless other.nil?
        end
      end
      alias >> connects_to
    end
  end
end
