# frozen_string_literal: true

module Logicuit
  module Circuits
    module SystemLevel
      # TD4
      class CpuTd4 < Base
        tag :TD4

        define_inputs :in0, :in1, :in2, :in3, clock: :ck

        define_outputs :led1, :led2, :led3, :led4

        assembling do |in0, in1, in2, in3, led1, led2, led3, led4|
          register_a = Sequential::Register4bit.new
          register_b = Sequential::Register4bit.new
          register_c = Sequential::Register4bit.new
          pc = Sequential::ProgramCounter.new
          rom = Rom::Timer.new
          dec = Combinational::Decoder.new
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
          alu.c >> dff.d

          [[:qa, in0, mux0, :a0], [:qb, in1, mux1, :a1], [:qc, in2, mux2, :a2], [:qd, in3, mux3, :a3]].each do |reg_out, in_port, mux, alu_in|
            register_a.send(reg_out) >> mux.c0
            register_b.send(reg_out) >> mux.c1
            in_port >> mux.c2
            Signals::Signal.new >> mux.c3
            dec.sel_a >> mux.a
            dec.sel_b >> mux.b
            mux.y >> alu.send(alu_in)
          end

          register_c.qa >> led4
          register_c.qb >> led3
          register_c.qc >> led2
          register_c.qd >> led1

          pc.qa >> rom.a0
          pc.qb >> rom.a1
          pc.qc >> rom.a2
          pc.qd >> rom.a3
          rom.d0 >> alu.b0
          rom.d1 >> alu.b1
          rom.d2 >> alu.b2
          rom.d3 >> alu.b3
          rom.d4 >> dec.op0
          rom.d5 >> dec.op1
          rom.d6 >> dec.op2
          rom.d7 >> dec.op3
          dec.ld0 >> register_a.ld
          dec.ld1 >> register_b.ld
          dec.ld2 >> register_c.ld
          dec.ld3 >> pc.ld
          dff.q >> dec.c_flag

          [register_a, register_b, pc, rom, dec]
        end

        def to_s
          p_a = "(#{@a || "0000"})"
          p_b = "(#{@b || "0000"})"

          register_a, register_b, pc, rom, dec = components
          @a = a = "#{register_a.qd}#{register_a.qc}#{register_a.qb}#{register_a.qa}"
          @b = b = "#{register_b.qd}#{register_b.qc}#{register_b.qb}#{register_b.qa}"
          p = "#{pc.qd}#{pc.qc}#{pc.qb}#{pc.qa}"
          o = "#{led1}#{led2}#{led3}#{led4}"
          i = "#{in3}#{in2}#{in1}#{in0}"
          m = "#{rom.d3}#{rom.d2}#{rom.d1}#{rom.d0}"
          c = "-(#{dec.c_flag})"
          loc = p.to_i(2)

          l1 = led1.current ? "*" : " "
          l2 = led2.current ? "*" : " "
          l3 = led3.current ? "*" : " "
          l4 = led4.current ? "*" : " "

          <<~OUTPUT

              #{l1 * 7}#{" " * 7}#{l2 * 7}#{" " * 7}#{l3 * 7}#{" " * 7}#{l4 * 7}
             #{l1 * 9}#{" " * 5}#{l2 * 9}#{" " * 5}#{l3 * 9}#{" " * 5}#{l4 * 9}
            #{l1 * 11}#{" " * 3}#{l2 * 11}#{" " * 3}#{l3 * 11}#{" " * 3}#{l4 * 11}
             #{l1 * 9}#{" " * 5}#{l2 * 9}#{" " * 5}#{l3 * 9}#{" " * 5}#{l4 * 9}
              #{l1 * 7}#{" " * 7}#{l2 * 7}#{" " * 7}#{l3 * 7}#{" " * 7}#{l4 * 7}

            +-----------------------------------------------+     #{loc ==  0 ? ">" : " "} OUT 0111
            |                                               |     #{loc ==  1 ? ">" : " "} ADD A,0001
            +--->|rg_a|#{p_a}----->|   |                    |     #{loc ==  2 ? ">" : " "} JNC 0001
            |    |#{a}|            |   |                    |     #{loc ==  3 ? ">" : " "} ADD A,0001
            |                      |   |                    |     #{loc ==  4 ? ">" : " "} JNC 0011
            +--->|rg_b|#{p_b}----->|   |----------->|   |---+     #{loc ==  5 ? ">" : " "} OUT 0110
            |    |#{b}|            |   |            |   |         #{loc ==  6 ? ">" : " "} ADD A,0001
            |                      |SEL|            |ALU|         #{loc ==  7 ? ">" : " "} JNC 0110
            +--->| out|  |  in|--->|   |            |   |         #{loc ==  8 ? ">" : " "} ADD A,0001
            |    |#{o}|  |#{i}|    |   |  |  im|--->|   |-#{c}    #{loc ==  9 ? ">" : " "} JNC 1000
            |                      |   |  |#{m}|                  #{loc == 10 ? ">" : " "} OUT 0000
            +--->|  pc|  (0000)--->|   |                          #{loc == 11 ? ">" : " "} OUT 0100
                 |#{p}|                                           #{loc == 12 ? ">" : " "} ADD A,0001
                                                                  #{loc == 13 ? ">" : " "} JNC 1010
                                                                  #{loc == 14 ? ">" : " "} OUT 1000
                                                                  #{loc == 15 ? ">" : " "} JMP 1111
          OUTPUT
        end
      end
    end
  end
end
