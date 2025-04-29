# frozen_string_literal: true

module Logicuit
  module Circuits
    module Sequential
      # Program Counter
      class ProgramCounter < DSL
        diagram <<~DIAGRAM
          (A)---|  |---(QA)
          (B)---|  |---(QB)
          (C)---|PC|---(QC)
          (D)---|  |---(QD)
          (LD)--|  |
        DIAGRAM

        inputs :a, :b, :c, :d, :ld, clock: :ck

        outputs :qa, :qb, :qc, :qd

        assembling do
          # inputs :cin, :a0, :b0, :a1, :b1, :a2, :b2, :a3, :b3
          fadd = Combinational::FullAdder4bit.new(0, 0, 1, 0, 0, 0, 0, 0, 0)

          [[a, qa, fadd.a0, fadd.s0], [b, qb, fadd.a1, fadd.s1], [c, qc, fadd.a2, fadd.s2],
           [d, qd, fadd.a3, fadd.s3]].each do |input, output, fadd_in, fadd_out|
            next if input.nil? || output.nil? || fadd_in.nil? || fadd_out.nil?

            dff = Sequential::DFlipFlop.new
            mux = Combinational::Multiplexer2to1.new
            input >> mux.c0
            dff.q >> fadd_in
            fadd_out >> mux.c1
            ld    >> mux.a
            mux.y >> dff.d
            dff.q >> output
          end
        end
      end
    end
  end
end
