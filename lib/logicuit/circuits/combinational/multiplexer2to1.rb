# frozen_string_literal: true

module Logicuit
  module Circuits
    module Combinational
      # A Multiplexer with 2 inputs and 1 output
      #
      # C0 | C1 | A | Y
      # ---+----+---+---
      #  0 |  x | 0 | 0
      #  1 |  x | 0 | 1
      #  x |  0 | 1 | 0
      #  x |  1 | 1 | 1
      class Multiplexer2To1 < Base
        define_inputs :c0, :c1, :a

        define_outputs y: lambda { |c0, c1, a|
          (c0 && !a) || (c1 && a)
        }

        diagram <<-DIAGRAM
          (C0)---------|
                       |AND|--+
               +-|NOT|-|      +--|
               |                 |OR|--(Y)
          (C1)---------|      +--|
               |       |AND|--+
          (A)--+-------|
        DIAGRAM
      end
    end
  end
end
