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

      def to_s
        signals.map { _1.current ? "1" : "0" }.join
      end

      def set(vals)
        vals.split("").zip(signals).each do |v, o|
          v == "1" ? o.on : o.off
        end
      end
    end
  end
end
