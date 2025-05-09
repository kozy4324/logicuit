# frozen_string_literal: true

# rbs_inline: enabled

module Logicuit
  module Circuits
    module Sequential
      # 1 bit CPU with a Multiplexer
      # Input A is H, MOV A,A
      # Input A is L, NOT A
      class OneBitCpu < DSL
        diagram <<~DIAGRAM
          +-----------------------------+
          |                             |
          +----|   |---+---------|   |  |
               |DFF|   |         |   |  |
          (CK)-|>  |   +--|NOT|--|MUX|--+--(Y)
                                 |   |
                            (A)--|   |
        DIAGRAM

        attr_reader :a, :y #: Signals::Signal

        inputs :a, clock: :ck

        outputs :y

        assembling do
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
