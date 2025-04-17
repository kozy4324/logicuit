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
        others = others.signals if others.is_a?(SignalGroup)
        @signals.zip(others).each { _1 >> _2 unless _1.nil? || _2.nil? }
      end
      alias >> connects_to
    end
  end
end
