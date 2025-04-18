# frozen_string_literal: true

module Logicuit
  module Circuits
    module Td4
      # Decoder class
      class Decoder < DSL
        inputs :op3, :op2, :op1, :op0, :c_flag

        outputs sel_b: -> { op1 },
                sel_a: -> { op3 || op0 },
                ld0: -> { op3 || op2 },
                ld1: -> { op3 || !op2 },
                ld2: -> { !op3 || op2 },
                ld3: -> { !op3 || !op2 || (!op0 && c_flag) }

        truth_table <<~TRUTH_TABLE
          | OP3 | OP2 | OP1 | OP0 | C_FLAG | SEL_B | SEL_A | LD0 | LD1 | LD2 | LD3 |
          | --- | --- | --- | --- | ------ | ----- | ----- | --- | --- | --- | --- |
          |   0 |   0 |   0 |   0 |      x |     0 |     0 |   0 |   1 |   1 |   1 | # ADD A,Im
          |   0 |   0 |   0 |   1 |      x |     0 |     1 |   0 |   1 |   1 |   1 | # MOV A,B
          |   0 |   0 |   1 |   0 |      x |     1 |     0 |   0 |   1 |   1 |   1 | # IN  A
          |   0 |   0 |   1 |   1 |      x |     1 |     1 |   0 |   1 |   1 |   1 | # MOV A,Im
          |   0 |   1 |   0 |   0 |      x |     0 |     0 |   1 |   0 |   1 |   1 | # MOV B,A
          |   0 |   1 |   0 |   1 |      x |     0 |     1 |   1 |   0 |   1 |   1 | # ADD B,Im
          |   0 |   1 |   1 |   0 |      x |     1 |     0 |   1 |   0 |   1 |   1 | # IN  B
          |   0 |   1 |   1 |   1 |      x |     1 |     1 |   1 |   0 |   1 |   1 | # MOV B,Im
          |   1 |   0 |   0 |   1 |      x |     0 |     1 |   1 |   1 |   0 |   1 | # OUT B
          |   1 |   0 |   1 |   1 |      x |     1 |     1 |   1 |   1 |   0 |   1 | # OUT Im
          |   1 |   1 |   1 |   0 |      0 |     1 |     1 |   1 |   1 |   1 |   0 | # JNC(C=0)
          |   1 |   1 |   1 |   0 |      1 |     1 |     1 |   1 |   1 |   1 |   1 | # JNC(C=1)
          |   1 |   1 |   1 |   1 |      x |     1 |     1 |   1 |   1 |   1 |   0 | # JMP
        TRUTH_TABLE
      end
    end
  end
end
