# frozen_string_literal: true

module Logicuit
  # OR circuit
  class Or
    def initialize(a, b) # rubocop:disable Naming/MethodParameterName
      @a = a
      @b = b
    end

    def signal
      [@a == 1 || @b == 1 ? 1 : 0]
    end
  end
end
