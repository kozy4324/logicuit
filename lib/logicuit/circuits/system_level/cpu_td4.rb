# frozen_string_literal: true

module Logicuit
  module Circuits
    module SystemLevel
      # TD4
      class CpuTd4 < Base
        tag :TD4

        define_inputs :ld0, :ld1, :ld2, :ld3, :sel_a, :sel_b, :im_d0, :im_d1, :im_d2, :im_d3, clock: :ck

        assembling do |ld0, ld1, ld2, ld3, sel_a, sel_b, im_d0, im_d1, im_d2, im_d3| # rubocop:disable Metrics/ParameterLists,Metrics/BlockLength
          register_a = Sequential::Register4bit.new
          register_b = Sequential::Register4bit.new
          register_c = Sequential::Register4bit.new
          register_d = Sequential::Register4bit.new
          mux4_0 = Combinational::Multiplexer4to1.new # rubocop:disable Naming/VariableNumber
          mux4_1 = Combinational::Multiplexer4to1.new # rubocop:disable Naming/VariableNumber
          mux4_2 = Combinational::Multiplexer4to1.new # rubocop:disable Naming/VariableNumber
          mux4_3 = Combinational::Multiplexer4to1.new # rubocop:disable Naming/VariableNumber
          full_adder_4bit = Combinational::FullAdder4bit.new

          [%i[s0 a], %i[s1 b], %i[s2 c], %i[s3 d]].each do |sel, reg|
            full_adder_4bit.send(sel) >> register_a.send(reg)
            full_adder_4bit.send(sel) >> register_b.send(reg)
            full_adder_4bit.send(sel) >> register_c.send(reg)
            full_adder_4bit.send(sel) >> register_d.send(reg)
          end
          ld0.on
          ld0 >> register_a.ld
          ld1.on
          ld1 >> register_b.ld
          ld2.on
          ld2 >> register_c.ld
          ld3.on
          ld3 >> register_d.ld
          [[:qa, mux4_0, :a0], [:qb, mux4_1, :a1], [:qc, mux4_2, :a2], [:qd, mux4_3, :a3]].each do |output, mux, alu_in|
            register_a.send(output) >> mux.c0
            register_b.send(output) >> mux.c1
            register_c.send(output) >> mux.c2
            register_d.send(output) >> mux.c3
            sel_a >> mux.a
            sel_b >> mux.b
            mux.y >> full_adder_4bit.send(alu_in)
          end
          im_d0 >> full_adder_4bit.b0
          im_d1 >> full_adder_4bit.b1
          im_d2 >> full_adder_4bit.b2
          im_d3 >> full_adder_4bit.b3

          [register_a, register_b, register_c, register_d, mux4_0, mux4_1, mux4_2, mux4_3, full_adder_4bit]
        end

        def to_s # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
          register_a, register_b, register_c, register_d, mux4_0, mux4_1, mux4_2, mux4_3, full_adder_4bit = components # rubocop:disable Lint/UselessAssignment,Naming/VariableNumber
          <<~OUTPUT
            register_a: #{register_a.qd}#{register_a.qc}#{register_a.qb}#{register_a.qa}
            register_b: #{register_b.qd}#{register_b.qc}#{register_b.qb}#{register_b.qa}
            register_c: #{register_c.qd}#{register_c.qc}#{register_c.qb}#{register_c.qa}
            register_d: #{register_d.qd}#{register_d.qc}#{register_d.qb}#{register_d.qa}

            alu_in_a: #{full_adder_4bit.a3}#{full_adder_4bit.a2}#{full_adder_4bit.a1}#{full_adder_4bit.a0}
            alu_in_b: #{full_adder_4bit.b3}#{full_adder_4bit.b2}#{full_adder_4bit.b1}#{full_adder_4bit.b0}
            alu_out : #{full_adder_4bit.s3}#{full_adder_4bit.s2}#{full_adder_4bit.s1}#{full_adder_4bit.s0}

            ld0: #{ld0}
            ld1: #{ld1}
            ld2: #{ld2}
            ld3: #{ld3}
            sel_a: #{sel_a}
            sel_b: #{sel_b}
            ImData: #{im_d3}#{im_d2}#{im_d1}#{im_d0}
          OUTPUT
        end
      end
    end
  end
end
