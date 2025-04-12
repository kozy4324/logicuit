# frozen_string_literal: true

module Logicuit
  module Circuits
    module Sequential
      # 1 bit CPU with a Multiplexer
      # Input A is H, MOV A,A
      # Input A is L, NOT A
      class OneBitCpu < Base
        tag :ONE_BIT_CPU

        diagram <<~DIAGRAM
          +-----------------------------+
          |                             |
          +----|   |---+---------|      |
               |DFF|   |         |      |
          (CK)-|>  |   +--|NOT|--|MUX|--+--(Y)
                                 |
                            (A)--|
        DIAGRAM

        define_inputs :a, clock: :ck

        define_outputs :y

        assembling do |a, y|
          dff = Sequential::DFlipFlop.new
          not_gate = Gates::Not.new
          mux = Combinational::Multiplexer2to1.new

          dff.q >> mux.c0
          dff.q >> not_gate.a
          not_gate.y >> mux.c1
          a >> mux.a
          mux.y >> dff.d
          mux.y >> y
        end
      end
    end
  end
end
