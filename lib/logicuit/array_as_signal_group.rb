# frozen_string_literal: true

# Logicuit module
module Logicuit
  # Treats Array#>> as SignalGroup#>> for the purpose of connecting signals
  module ArrayAsSignalGroup
    refine Array do
      def >>(other)
        to_signal_group.connects_to(other)
      end

      def to_signal_group
        Signals::SignalGroup.new(*self)
      end
    end
  end
end
