# frozen_string_literal: true

module Logicuit
  module Circuits
    module Combinational
      # HalfAdder class
      class Decoder < Base
        tag :DEC

        diagram <<~DIAGRAM
          TODO: implement decoder diagram
        DIAGRAM

        define_inputs :op3, :op2, :op1, :op0, :c_flag

        define_outputs :sel_b, :sel_a, :ld0, :ld1, :ld2, :ld3

        truth_table <<~TRUTH_TABLE
          | OP3 | OP2 | OP1 | OP0 | C_FLAG | SEL_B | SEL_A | LD0 | LD1 | LD2 | LD3 |
          | --- | --- | --- | --- | ------ | ----- | ----- | --- | --- | --- | --- |
          |   0 |   0 |   0 |   0 |      x |     0 |     0 |   0 |   1 |   1 |   1 |
          |   0 |   0 |   0 |   1 |      x |     0 |     1 |   0 |   1 |   1 |   1 |
          |   0 |   0 |   1 |   0 |      x |     1 |     0 |   0 |   1 |   1 |   1 |
          |   0 |   0 |   1 |   1 |      x |     1 |     1 |   0 |   1 |   1 |   1 |
          |   0 |   1 |   0 |   0 |      x |     0 |     0 |   1 |   0 |   1 |   1 |
          |   0 |   1 |   0 |   1 |      x |     0 |     1 |   1 |   0 |   1 |   1 |
          |   0 |   1 |   1 |   0 |      x |     1 |     0 |   1 |   0 |   1 |   1 |
          |   0 |   1 |   1 |   1 |      x |     1 |     1 |   1 |   0 |   1 |   1 |
          |   1 |   0 |   0 |   1 |      x |     0 |     1 |   1 |   1 |   0 |   1 |
          |   1 |   0 |   1 |   1 |      x |     1 |     1 |   1 |   1 |   0 |   1 |
          |   1 |   1 |   1 |   0 |      0 |     1 |     1 |   1 |   1 |   1 |   0 |
          |   1 |   1 |   1 |   0 |      1 |     x |     x |   1 |   1 |   1 |   1 |
          |   1 |   1 |   1 |   1 |      x |     1 |     1 |   1 |   1 |   1 |   0 |
        TRUTH_TABLE
      end
    end
  end
end
