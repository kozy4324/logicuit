# frozen_string_literal: true

module Logicuit
  module Circuits
    module Td4
      # TD4 CPU
      class Cpu < DSL
        inputs :in0, :in1, :in2, :in3, clock: :ck

        outputs :led1, :led2, :led3, :led4

        assembling do |in0, in1, in2, in3, led1, led2, led3, led4|
          register_a = Sequential::Register4bit.new
          register_b = Sequential::Register4bit.new
          register_c = Sequential::Register4bit.new
          pc = Sequential::ProgramCounter.new
          rom = Rom.new
          dec = Decoder.new
          mux0 = Combinational::Multiplexer4to1.new
          mux1 = Combinational::Multiplexer4to1.new
          mux2 = Combinational::Multiplexer4to1.new
          mux3 = Combinational::Multiplexer4to1.new
          alu = Combinational::FullAdder4bit.new
          dff = Sequential::DFlipFlop.new

          alu.s0 >> [register_a.a, register_b.a, register_c.a, pc.a]
          alu.s1 >> [register_a.b, register_b.b, register_c.b, pc.b]
          alu.s2 >> [register_a.c, register_b.c, register_c.c, pc.c]
          alu.s3 >> [register_a.d, register_b.d, register_c.d, pc.d]
          alu.c >> dff.d

          [[:qa, in0, mux0, :a0], [:qb, in1, mux1, :a1], [:qc, in2, mux2, :a2], [:qd, in3, mux3, :a3]].each do |reg_out, in_port, mux, alu_in|
            register_a[reg_out] >> mux.c0
            register_b[reg_out] >> mux.c1
            in_port >> mux.c2
            Signals::Signal.new >> mux.c3
            dec.sel_a >> mux.a
            dec.sel_b >> mux.b
            mux.y >> alu[alu_in]
          end

          register_c[:qa, :qb, :qc, :qd] >> [led4, led3, led2, led1]
          pc[:qa, :qb, :qc, :qd] >> rom[:a0, :a1, :a2, :a3]
          rom[:d0, :d1, :d2, :d3] >> alu[:a0, :a1, :a2, :a3]
          rom[:d4, :d5, :d6, :d7] >> dec[:op0, :op1, :op2, :op3]
          dec[:ld0, :ld1, :ld2, :ld3] >> [register_a.ld, register_b.ld, register_c.ld, pc.ld]
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
