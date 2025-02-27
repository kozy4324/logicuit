# frozen_string_literal: true

module Logicuit
  module Gates
    # base class for all gates
    class Base
      def initialize
        # noop
      end

      def evaluate
        raise NotImplementedError, "Subclasses must implement the evaluate method"
      end
    end
  end
end
