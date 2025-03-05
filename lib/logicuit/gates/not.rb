# frozen_string_literal: true

module Logicuit
  module Gates
    # NOT gate
    class Not < Base
      define_inputs :a

      define_outputs y: ->(a) { !a } # rubocop:disable Style/SymbolProc

      diagram <<~DIAGRAM
        (A)-|NOT|-(Y)
      DIAGRAM
    end
  end
end
