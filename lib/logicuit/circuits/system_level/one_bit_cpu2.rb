# frozen_string_literal: true

module Logicuit
  module Circuits
    module SystemLevel
      # 1 bit CPU with a Multiplexer
      # Input A is H, MOV A,A
      # Input A is L, NOT A
      class OneBitCpu2 < Base
        tag :ONE_BIT_CPU2

        diagram <<~DIAGRAM
          +------------------------+
          |              +-------------(Y)
          +----|   |-+---+---|     |
               |DFF| |       |     |
          (CK)-|>  | +-|NOT|-|MUX|-+
                             |
                       (A)---|
        DIAGRAM

        define_inputs :a, clock: :ck

        define_outputs :y

        assembling do |a, y|
          dff = Sequential::DFlipFlop.new
          not_gate = Gates::Not.new
          mux = Combinational::Multiplexer2to1.new

          dff.q >> y
          dff.q >> mux.c0
          dff.q >> not_gate.a
          not_gate.y >> mux.c1
          a >> mux.a
          mux.y >> dff.d
        end
      end
    end
  end
end
