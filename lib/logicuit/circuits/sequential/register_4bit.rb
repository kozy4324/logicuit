# frozen_string_literal: true

module Logicuit
  module Circuits
    module Sequential
      # 4 bit register
      class Register4bit < Base
        tag :REG4

        diagram <<~DIAGRAM
                  +---------------------+
                  +-|                   |
          (A)-------|MUX|-------|DFF|---+---(QA)
                +---|       +---|
                |           |
                | +---------------------+
                | +-|       |           |
          (B)-------|MUX|-------|DFF|---+---(QB)
                +---|       +---|
                |           |
                | +---------------------+
                | +-|       |           |
          (C)-------|MUX|-------|DFF|---+---(QC)
                +---|       +---|
                |           |
                | +---------------------+
                | +-|       |           |
          (D)-------|MUX|-------|DFF|---+---(QD)
                +---|       +---|
          (LD)--+     (CK)--+
        DIAGRAM

        define_inputs :a, :b, :c, :d, :ld, clock: :ck

        define_outputs :qa, :qb, :qc, :qd

        assembling do |a, b, c, d, ld, qa, qb, qc, qd|
          [[a, qa], [b, qb], [c, qc], [d, qd]].each do |input, output|
            dff = Sequential::DFlipFlop.new
            mux = Combinational::Multiplexer2to1.new
            input >> mux.c0
            dff.q >> mux.c1
            ld    >> mux.a
            mux.y >> dff.d
            dff.q >> output
          end
        end

        truth_table <<~TRUTH_TABLE
          | CK | A | B | C | D | LD | QA | QB | QC | QD |
          | -- | - | - | - | - | -- | -- | -- | -- | -- |
          |  ^ | x | x | x | x |  0 |  A |  B |  C |  D |
          |  ^ | x | x | x | x |  1 | QA | QB | QC | QD |
        TRUTH_TABLE
      end
    end
  end
end
