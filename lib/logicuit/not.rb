# frozen_string_literal: true

module Logicuit
  # NOT circuit
  class Not
    def initialize(a) # rubocop:disable Naming/MethodParameterName
      @a = a.respond_to?(:call) ? a : -> { a }
    end

    def signal
      a = @a.call
      [a == 1 ? -> { 0 } : -> { 1 }]
    end
  end
end
