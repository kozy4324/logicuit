# frozen_string_literal: true

module Logicuit
  module Circuits
    module SystemLevel
      # TD4
      class CpuTd4 < Base
        tag :TD4

        define_inputs :ld0, :ld1, :ld2, :ld3, :sel_a, :sel_b, :im0, :im1, :im2, :im3, clock: :ck

        assembling do |ld0, ld1, ld2, ld3, sel_a, sel_b, im0, im1, im2, im3| # rubocop:disable Metrics/ParameterLists,Metrics/BlockLength
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
          ld0.on
          ld0 >> register_a.ld
          ld1.on
          ld1 >> register_b.ld
          ld2.on
          ld2 >> register_c.ld
          ld3.on
          ld3 >> register_d.ld
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

          [register_a, register_b, register_c, register_d, mux0, mux1, mux2, mux3, alu]
        end

        def to_s # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
          register_a, register_b, register_c, register_d, mux0, mux1, mux2, mux3, alu = components
          <<~OUTPUT
            register_a: #{register_a.d}#{register_a.c}#{register_a.b}#{register_a.a} -> #{register_a.qd}#{register_a.qc}#{register_a.qb}#{register_a.qa}
            register_b: #{register_b.d}#{register_b.c}#{register_b.b}#{register_b.a} -> #{register_b.qd}#{register_b.qc}#{register_b.qb}#{register_b.qa}
            register_c: #{register_c.d}#{register_c.c}#{register_c.b}#{register_c.a} -> #{register_c.qd}#{register_c.qc}#{register_c.qb}#{register_c.qa}
            register_d: #{register_d.d}#{register_d.c}#{register_d.b}#{register_d.a} -> #{register_d.qd}#{register_d.qc}#{register_d.qb}#{register_d.qa}

            mux: #{mux3.y}#{mux2.y}#{mux1.y}#{mux0.y}

            alu_in : #{alu.a3}#{alu.a2}#{alu.a1}#{alu.a0} + #{alu.b3}#{alu.b2}#{alu.b1}#{alu.b0}
            alu_out: #{alu.s3}#{alu.s2}#{alu.s1}#{alu.s0}

            ld0: #{ld0}, ld1: #{ld1}, ld2: #{ld2}, ld3: #{ld3}
            sel: #{sel_b}#{sel_a}
            ImData: #{im3}#{im2}#{im1}#{im0}
          OUTPUT
        end
      end
    end
  end
end
