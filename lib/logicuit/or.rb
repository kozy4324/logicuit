# frozen_string_literal: true

module Logicuit
  # OR circuit
  class Or
    def initialize(a, b) # rubocop:disable Naming/MethodParameterName
      @a = a.respond_to?(:call) ? a : -> { a }
      @b = b.respond_to?(:call) ? b : -> { b }
    end

    def signal
      a = @a.call
      b = @b.call
      [a == 1 || b == 1 ? 1 : 0]
    end
  end
end
