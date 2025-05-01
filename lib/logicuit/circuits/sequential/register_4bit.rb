# frozen_string_literal: true

# rbs_inline: enabled

module Logicuit
  module Circuits
    module Sequential
      # 4 bit register
      class Register4bit < DSL
        diagram <<~DIAGRAM
                  +---------------------+
                  +-|   |               |
          (A)-------|MUX|-------|DFF|---+---(QA)
                +---|   |   +---|   |
                |           |
                | +---------------------+
                | +-|   |   |           |
          (B)-------|MUX|-------|DFF|---+---(QB)
                +---|   |   +---|   |
                |           |
                | +---------------------+
                | +-|   |   |           |
          (C)-------|MUX|-------|DFF|---+---(QC)
                +---|   |   +---|   |
                |           |
                | +---------------------+
                | +-|   |   |           |
          (D)-------|MUX|-------|DFF|---+---(QD)
                +---|   |   +---|   |
          (LD)--+     (CK)--+
        DIAGRAM

        attr_reader :a, :b, :c, :d, :ld, :qa, :qb, :qc, :qd #: Signals::Signal

        inputs :a, :b, :c, :d, :ld, clock: :ck

        outputs :qa, :qb, :qc, :qd

        assembling do
          [[a, qa], [b, qb], [c, qc], [d, qd]].each do |input, output|
            next if input.nil? || output.nil?

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
