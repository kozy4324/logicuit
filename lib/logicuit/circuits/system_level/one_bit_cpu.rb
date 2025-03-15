# frozen_string_literal: true

module Logicuit
  module Circuits
    module SystemLevel
      # 1 bit CPU
      class OneBitCpu < Base
        tag :ONE_BIT_CPU

        diagram <<~DIAGRAM
          +-------------+
          |             |
          +-|NOT|-|   |-+-(Y)
                  |DFF|
             (CK)-|>  |
        DIAGRAM

        define_inputs clock: :ck

        define_outputs :y

        assembling do |y|
          dff = Sequential::DFlipFlop.new
          not_gate = Gates::Not.new

          dff.q >> not_gate.a
          not_gate.y >> dff.d

          dff.q >> y
        end

        truth_table <<~TRUTH_TABLE
          | CK | prev Y | Y |
          | -- | ------ | - |
          |  ^ |      0 | 1 |
          |  ^ |      1 | 0 |
        TRUTH_TABLE
      end
    end
  end
end
