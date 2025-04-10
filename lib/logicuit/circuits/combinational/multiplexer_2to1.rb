# frozen_string_literal: true

module Logicuit
  module Circuits
    module Combinational
      # A Multiplexer with 2 inputs and 1 output
      class Multiplexer2to1 < Base
        tag :MUX, :MUX2, :MUX2to1

        diagram <<~DIAGRAM
          (C0)---------|
                       |AND|--+
               +-|NOT|-|      +--|
               |                 |OR|--(Y)
          (C1)---------|      +--|
               |       |AND|--+
          (A)--+-------|
        DIAGRAM

        define_inputs :c0, :c1, :a

        define_outputs y: ->(c0, c1, a) { (c0 && !a) || (c1 && a) }

        truth_table <<~TRUTH_TABLE
          | C0 | C1 | A | Y |
          | -- | -- | - | - |
          |  0 |  x | 0 | 0 |
          |  1 |  x | 0 | 1 |
          |  x |  0 | 1 | 0 |
          |  x |  1 | 1 | 1 |
        TRUTH_TABLE
      end
    end
  end
end
