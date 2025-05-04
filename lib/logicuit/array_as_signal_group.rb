# frozen_string_literal: true

# rbs_inline: enabled

# Logicuit module
module Logicuit
  # Treats Array#>> as SignalGroup#>> for the purpose of connecting signals
  module ArrayAsSignalGroup
    refine Array do
      #: def >>: (untyped other) -> void
      def >>(other)
        Signals::SignalGroup.new(*self).connects_to(other) # steep:ignore
      end
    end
  end
end

# @rbs!
#   class Array[unchecked out T]
#     def >>: (untyped other) -> void
#   end
