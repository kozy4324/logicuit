# frozen_string_literal: true

module Logicuit
  module Circuits
    module SystemLevel
      # TD4
      class CpuTd4 < Base
        tag :TD4

        define_inputs :ld0, :ld1, :ld2, :ld3, :sel_a, :sel_b, :im0, :im1, :im2, :im3, :in0, :in1, :in2, :in3, clock: :ck

        define_outputs :carry_flag, :led1, :led2, :led3, :led4

        assembling do |ld0, ld1, ld2, ld3, sel_a, sel_b, im0, im1, im2, im3, in0, in1, in2, in3, carry_flag, led1, led2, led3, led4| # rubocop:disable Layout/LineLength
          register_a = Sequential::Register4bit.new
          register_b = Sequential::Register4bit.new
          register_c = Sequential::Register4bit.new
          pc = Sequential::ProgramCounter.new
          mux0 = Combinational::Multiplexer4to1.new
          mux1 = Combinational::Multiplexer4to1.new
          mux2 = Combinational::Multiplexer4to1.new
          mux3 = Combinational::Multiplexer4to1.new
          alu = Combinational::FullAdder4bit.new
          dff = Sequential::DFlipFlop.new

          [%i[s0 a], %i[s1 b], %i[s2 c], %i[s3 d]].each do |sel, reg|
            alu.send(sel) >> register_a.send(reg)
            alu.send(sel) >> register_b.send(reg)
            alu.send(sel) >> register_c.send(reg)
            alu.send(sel) >> pc.send(reg)
          end
          ld0.on >> register_a.ld
          ld1.on >> register_b.ld
          ld2.on >> register_c.ld
          ld3.on >> pc.ld
          [[:qa, in0, mux0, :a0], [:qb, in1, mux1, :a1], [:qc, in2, mux2, :a2], [:qd, in3, mux3, :a3]].each do |reg_out, in_port, mux, alu_in| # rubocop:disable Layout/LineLength
            register_a.send(reg_out) >> mux.c0
            register_b.send(reg_out) >> mux.c1
            in_port >> mux.c2
            Signals::Signal.new.off >> mux.c3
            sel_a >> mux.a
            sel_b >> mux.b
            mux.y >> alu.send(alu_in)
          end
          register_c.qa >> led4
          register_c.qb >> led3
          register_c.qc >> led2
          register_c.qd >> led1
          im0 >> alu.b0
          im1 >> alu.b1
          im2 >> alu.b2
          im3 >> alu.b3
          alu.c >> dff.d
          dff.q >> carry_flag

          [register_a, register_b, register_c, pc, alu]
        end

        define_instructions "ADD A,Im" => ->(im3, im2, im1, im0) { bulk_set "0111 00 #{im0}#{im1}#{im2}#{im3}" },
                            "ADD B,Im" => ->(im3, im2, im1, im0) { bulk_set "1011 10 #{im0}#{im1}#{im2}#{im3}" },
                            "MOV A,Im" => ->(im3, im2, im1, im0) { bulk_set "0111 11 #{im0}#{im1}#{im2}#{im3}" },
                            "MOV B,Im" => ->(im3, im2, im1, im0) { bulk_set "1011 11 #{im0}#{im1}#{im2}#{im3}" },
                            "MOV A,B" => -> { bulk_set "0111 10 0000" },
                            "MOV B,A" => -> { bulk_set "1011 00 0000" },
                            "JMP Im" => ->(im3, im2, im1, im0) { bulk_set "1110 11 #{im0}#{im1}#{im2}#{im3}" },
                            "JNC Im" => ->(im3, im2, im1, im0, c) { bulk_set "111#{c} 11 #{im0}#{im1}#{im2}#{im3}" },
                            "IN A" => -> { bulk_set "0111 01 0000" },
                            "IN B" => -> { bulk_set "1011 01 0000" },
                            "OUT B" => -> { bulk_set "1101 10 0000" },
                            "OUT Im" => ->(im3, im2, im1, im0) { bulk_set "1101 11 #{im0}#{im1}#{im2}#{im3}" }

        def to_s
          register_a, register_b, register_c, pc, alu = components
          a = "#{register_a.qd}#{register_a.qc}#{register_a.qb}#{register_a.qa}"
          b = "#{register_b.qd}#{register_b.qc}#{register_b.qb}#{register_b.qa}"
          p = "#{pc.qd}#{pc.qc}#{pc.qb}#{pc.qa}"
          o = "#{led1}#{led2}#{led3}#{led4}"
          i = "#{in3}#{in2}#{in1}#{in0}"
          m = "#{im3}#{im2}#{im1}#{im0}"

          <<~OUTPUT
            +----------------------------------------------+
            |                                              |
            +-->|rg_a|----------->|   |                    |
            |   |#{a}|            |   |                    |
            |                     |   |                    |
            +-->|rg_b|----------->|   |----------->|   |---+
            |   |#{b}|            |   |            |   |
            |                     |SEL|            |ALU|
            +-->| out|  |  in|--->|   |            |   |
            |   |#{o}|  |#{i}|    |   |  |  im|--->|   |--(#{carry_flag})
            |                     |   |  |#{m}|
            +-->|  pc|  (0000)--->|   |
                |#{p}|
          OUTPUT
        end
      end
    end
  end
end
