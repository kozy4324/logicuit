# frozen_string_literal: true

module Logicuit
  module Circuits
    module SystemLevel
      # TD4
      class CpuTd4 < Base
        tag :TD4

        define_inputs :ld0, :ld1, :ld2, :ld3, :sel_a, :sel_b, :im0, :im1, :im2, :im3, clock: :ck

        assembling do |ld0, ld1, ld2, ld3, sel_a, sel_b, im0, im1, im2, im3|
          register_a = Sequential::Register4bit.new
          register_b = Sequential::Register4bit.new
          register_c = Sequential::Register4bit.new
          register_d = Sequential::Register4bit.new
          mux0 = Combinational::Multiplexer4to1.new
          mux1 = Combinational::Multiplexer4to1.new
          mux2 = Combinational::Multiplexer4to1.new
          mux3 = Combinational::Multiplexer4to1.new
          alu = Combinational::FullAdder4bit.new

          [%i[s0 a], %i[s1 b], %i[s2 c], %i[s3 d]].each do |sel, reg|
            alu.send(sel) >> register_a.send(reg)
            alu.send(sel) >> register_b.send(reg)
            alu.send(sel) >> register_c.send(reg)
            alu.send(sel) >> register_d.send(reg)
          end
          ld0.on >> register_a.ld
          ld1.on >> register_b.ld
          ld2.on >> register_c.ld
          ld3.on >> register_d.ld
          [[:qa, mux0, :a0], [:qb, mux1, :a1], [:qc, mux2, :a2], [:qd, mux3, :a3]].each do |output, mux, alu_in|
            register_a.send(output) >> mux.c0
            register_b.send(output) >> mux.c1
            register_c.send(output) >> mux.c2
            register_d.send(output) >> mux.c3
            sel_a >> mux.a
            sel_b >> mux.b
            mux.y >> alu.send(alu_in)
          end
          im0 >> alu.b0
          im1 >> alu.b1
          im2 >> alu.b2
          im3 >> alu.b3

          [register_a, register_b, register_c, register_d, alu]
        end

        define_instructions "ADD A,Im" => ->(im3, im2, im1, im0) { bulk_set "0111 00 #{im0}#{im1}#{im2}#{im3}" },
                            "ADD B,Im" => ->(im3, im2, im1, im0) { bulk_set "1011 01 #{im0}#{im1}#{im2}#{im3}" },
                            # "MOV A,Im" => -> { :do_something },
                            # "MOV B,Im" => -> { :do_something },
                            "MOV A,B" => -> { bulk_set "0111 10 0000" },
                            "MOV B,A" => -> { bulk_set "1011 00 0000" }
        # "JMP Im" => -> { :do_something },
        # "JNC Im" => -> { :do_something },
        # "IN A" => -> { :do_something },
        # "IN B" => -> { :do_something },
        # "OUT B" => -> { :do_something }

        def to_s
          register_a, register_b, register_c, register_d, alu = components
          <<~OUTPUT
            register_a: #{register_a.qd}#{register_a.qc}#{register_a.qb}#{register_a.qa}
            register_b: #{register_b.qd}#{register_b.qc}#{register_b.qb}#{register_b.qa}
            register_c: #{register_c.qd}#{register_c.qc}#{register_c.qb}#{register_c.qa}
            register_d: #{register_d.qd}#{register_d.qc}#{register_d.qb}#{register_d.qa}

            select: #{if sel_a.current && sel_b.current
                        "register_d"
                      elsif sel_b.current
                        "register_c"
                      else
                        sel_a.current ? "register_b" : "register_a"
                      end}

            ImData: #{im3}#{im2}#{im1}#{im0}

            alu_in : #{alu.a3}#{alu.a2}#{alu.a1}#{alu.a0} + #{alu.b3}#{alu.b2}#{alu.b1}#{alu.b0}
            alu_out: #{alu.s3}#{alu.s2}#{alu.s1}#{alu.s0}

            ld0: #{ld0}, ld1: #{ld1}, ld2: #{ld2}, ld3: #{ld3}
          OUTPUT
        end
      end
    end
  end
end
