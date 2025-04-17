# frozen_string_literal: true

# Logicuit module
module Logicuit
  # Treats Array#>> as SignalGroup#>> for the purpose of connecting signals
  module ArrayAsSignalGroup
    refine Array do
      def >>(other)
        if other.is_a?(::Logicuit::Signals::SignalGroup)
          zip(other.signals).each { _1 >> _2 unless _1.nil? || _2.nil? }
        else
          # assume signal_group is a Array of signals
          zip(other).each { _1 >> _2 unless _1.nil? || _2.nil? }
        end
      end
    end
  end
end
