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
          (LD)--|
        DIAGRAM

        inputs :a, :b, :c, :d, :ld, clock: :ck

        outputs :qa, :qb, :qc, :qd

        assembling do |a, b, c, d, ld, qa, qb, qc, qd|
          # inputs :cin, :a0, :b0, :a1, :b1, :a2, :b2, :a3, :b3
          fadd = Combinational::FullAdder4bit.new(0, 0, 1, 0, 0, 0, 0, 0, 0)

          [[a, qa, :a0, :s0], [b, qb, :a1, :s1], [c, qc, :a2, :s2],
           [d, qd, :a3, :s3]].each do |input, output, fadd_in, fadd_out|
            dff = Sequential::DFlipFlop.new
            mux = Combinational::Multiplexer2to1.new
            input >> mux.c0
            dff.q >> fadd.send(fadd_in)
            fadd.send(fadd_out) >> mux.c1
            ld    >> mux.a
            mux.y >> dff.d
            dff.q >> output
          end
        end
      end
    end
  end
end
