# frozen_string_literal: true

module Logicuit
  module Circuits
    module Combinational
      # FullAdder class
      class FullAdder < Base
        tag :FADD

        diagram <<~DIAGRAM
          (Cin)---+-|NOT|-----+
                  |           |
          (A)---+---|NOT|---+ |
                | |         | |
          (B)-+-----|NOT|-+ | +-|
              | | |       | +---|AND|---+
              +-----------------|       |
              | | |       | | |         +-|
              | | |       | | +-|         |
              | +---------------|AND|-----|
              | | |       +-----|         |
              | | |       | | |           |OR|-(S)
              | | +-------------|         |
              | | |       | +---|AND|-----|
              | | |       +-----|         |
              | | |       | | |         +-|
              | | +-------------|       |
              | +---------------|AND|---+
              +-----------------|
              | | |       | | |
              | | |       | | +-|
              | +---------------|AND|---+
              +-----------------|       |
              | | |       | |           +-|
              | | +-------------|         |
              | | |       | +---|AND|-----|
              +-----------------|         |
              | | |       |               |OR|-(C)
              | | +-------------|         |
              | +---------------|AND|-----|
              | | |       +-----|         |
              | | |                     +-|
              | | +-------------|       |
              | +---------------|AND|---+
              +-----------------|
        DIAGRAM

        define_inputs :cin, :a, :b

        define_outputs s: ->(cin, a, b) { (!cin && !a && b) || (!cin && a && !b) || (cin && !a && !b) || (cin && a && b) }, # rubocop:disable Layout/LineLength
                       c: ->(cin, a, b) { (!cin && a && b) || (cin && !a && b) || (cin && a && !b) || (cin && a && b) }

        truth_table <<~TRUTH_TABLE
          | Cin | A | B | C | S |
          | --- | - | - | - | - |
          |   0 | 0 | 0 | 0 | 0 |
          |   0 | 0 | 1 | 0 | 1 |
          |   0 | 1 | 0 | 0 | 1 |
          |   0 | 1 | 1 | 1 | 0 |
          |   1 | 0 | 0 | 0 | 1 |
          |   1 | 0 | 1 | 1 | 0 |
          |   1 | 1 | 0 | 1 | 0 |
          |   1 | 1 | 1 | 1 | 1 |
        TRUTH_TABLE
      end
    end
  end
end
