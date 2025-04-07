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

        define_outputs sel_b: ->(_, _, op1, _, _) { op1 },
                       sel_a: ->(op3, _, _, op0, _) { op3 || op0 },
                       ld0: ->(op3, op2, _, _, _) { op3 || op2 },
                       ld1: ->(op3, op2, _, _, _) { op3 || !op2 },
                       ld2: ->(op3, op2, _, _, _) { !op3 || op2 },
                       ld3: ->(op3, op2, _, op0, c_flag) { !op3 || !op2 || (!op0 && c_flag) }

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
          |   1 |   1 |   1 |   0 |      1 |     1 |     1 |   1 |   1 |   1 |   1 |
          |   1 |   1 |   1 |   1 |      x |     1 |     1 |   1 |   1 |   1 |   0 |
        TRUTH_TABLE
      end
    end
  end
end
