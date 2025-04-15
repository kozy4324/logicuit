# frozen_string_literal: true

module Logicuit
  module Circuits
    module Combinational
      # A Multiplexer with 4 inputs and 1 output
      class Multiplexer4to1 < DSL
        diagram <<~DIAGRAM
          (C0)---------------|
                         +---|AND|---+
                         | +-|       |
                         | |         |
          (C1)---------------|       +-|
                         +---|AND|-+   |
                 +-----------|     +---|
                 |       | |           |OR|--(Y)
          (C2)---------------|     +---|
               +-------------|AND|-+   |
               | |       | +-|       +-|
               | |       | |         |
          (C3)---------------|       |
               +-------------|AND|---+
               | +-----------|
               | |       | |
          (B)--+---|NOT|-+ |
                 |         |
          (A)----+-|NOT|---+
        DIAGRAM

        define_inputs :c0, :c1, :c2, :c3, :b, :a

        define_outputs y: lambda { |c0, c1, c2, c3, b, a|
          (c0 && !b && !a) || (c1 && !b && a) || (c2 && b && !a) || (c3 && b && a)
        }

        truth_table <<~TRUTH_TABLE
          | B | A | C0 | C1 | C2 | C3 | Y |
          | - | - | -- | -- | -- | -- | - |
          | 0 | 0 |  0 |  x |  x |  x | 0 |
          | 0 | 0 |  1 |  x |  x |  x | 1 |
          | 0 | 1 |  x |  0 |  x |  x | 0 |
          | 0 | 1 |  x |  1 |  x |  x | 1 |
          | 1 | 0 |  x |  x |  0 |  x | 0 |
          | 1 | 0 |  x |  x |  1 |  x | 1 |
          | 1 | 1 |  x |  x |  x |  0 | 0 |
          | 1 | 1 |  x |  x |  x |  1 | 1 |
        TRUTH_TABLE
      end
    end
  end
end
