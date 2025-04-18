# frozen_string_literal: true

# Logicuit module
module Logicuit
  # Treats Array#>> as SignalGroup#>> for the purpose of connecting signals
  module ArrayAsSignalGroup
    refine Array do
      def >>(other)
        Signals::SignalGroup.new(*self).connects_to(other)
      end
    end
  end
end
