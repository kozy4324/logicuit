# frozen_string_literal: true

module Logicuit
  module Circuits
    module Combinational
      # HalfAdder class
      class HalfAdder < Base
        diagram <<~DIAGRAM
          (A)---+-+---------|
                | |         |AND|--+
                | + +-|NOT|-|      +--|
                | | |                 |OR|--(S)
                | +---|NOT|-|      +--|
                |   |       |AND|--+
          (B)-+-----+-------|
              | |
              | +-----------|
              |             |AND|-----------(C)
              +-------------|
        DIAGRAM

        define_inputs :a, :b

        define_outputs c: ->(a, b) { a && b },
                       s: ->(a, b) { (a && !b) || (!a && b) }

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
