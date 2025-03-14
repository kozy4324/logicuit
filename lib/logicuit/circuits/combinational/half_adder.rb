# frozen_string_literal: true

module Logicuit
  module Circuits
    module Combinational
      # HalfAdder class
      class HalfAdder < Base
        define_inputs :a, :b

        define_outputs c: lambda { |a, b|
          a && b
        }, s: lambda { |a, b|
          (a && !b) || (!a && b)
        }

        diagram <<~DIAGRAM
          TODO: Implement the diagram
        DIAGRAM

        truth_table <<~TRUTH_TABLE
          | A | B | C | S |
          | - | - | - | - |
          | 0 | 0 | 0 | 0 |
          | 0 | 1 | 0 | 1 |
          | 1 | 0 | 0 | 1 |
          | 1 | 1 | 1 | 0 |
        TRUTH_TABLE
      end
    end
  end
end
