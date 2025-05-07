# frozen_string_literal: true

# rbs_inline: enabled

module Logicuit
  module Circuits
    module Td4
      # Timer
      class Rom < DSL
        attr_reader :a3, :a2, :a1, :a0, :d7, :d6, :d5, :d4, :d3, :d2, :d1, :d0 #: Signals::Signal

        inputs :a3, :a2, :a1, :a0

        outputs :d7, :d6, :d5, :d4, :d3, :d2, :d1, :d0

        def evaluate
          return unless initialized

          record = truth_table.find { |rec| input_targets.all? { |input| send(input).current == rec[input] } }
          return if record.nil?

          output_targets.map { |output| send(output).send(record[output] ? :on : :off) }
        end

        truth_table <<~TRUTH_TABLE
          | A3 | A2 | A1 | A0 | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |
          | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- |
          |  0 |  0 |  0 |  0 |  1 |  0 |  1 |  1 |  0 |  1 |  1 |  1 | # OUT 0111
          |  0 |  0 |  0 |  1 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  1 | # ADD A,0001
          |  0 |  0 |  1 |  0 |  1 |  1 |  1 |  0 |  0 |  0 |  0 |  1 | # JNC 0001
          |  0 |  0 |  1 |  1 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  1 | # ADD A,0001
          |  0 |  1 |  0 |  0 |  1 |  1 |  1 |  0 |  0 |  0 |  1 |  1 | # JNC 0011
          |  0 |  1 |  0 |  1 |  1 |  0 |  1 |  1 |  0 |  1 |  1 |  0 | # OUT 0110
          |  0 |  1 |  1 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  1 | # ADD A,0001
          |  0 |  1 |  1 |  1 |  1 |  1 |  1 |  0 |  0 |  1 |  1 |  0 | # JNC 0110
          |  1 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  1 | # ADD A,0001
          |  1 |  0 |  0 |  1 |  1 |  1 |  1 |  0 |  1 |  0 |  0 |  0 | # JNC 1000
          |  1 |  0 |  1 |  0 |  1 |  0 |  1 |  1 |  0 |  0 |  0 |  0 | # OUT 0000
          |  1 |  0 |  1 |  1 |  1 |  0 |  1 |  1 |  0 |  1 |  0 |  0 | # OUT 0100
          |  1 |  1 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  1 | # ADD A,0001
          |  1 |  1 |  0 |  1 |  1 |  1 |  1 |  0 |  1 |  0 |  1 |  0 | # JNC 1010
          |  1 |  1 |  1 |  0 |  1 |  0 |  1 |  1 |  1 |  0 |  0 |  0 | # OUT 1000
          |  1 |  1 |  1 |  1 |  1 |  1 |  1 |  1 |  1 |  1 |  1 |  1 | # JMP 1111
        TRUTH_TABLE
      end
    end
  end
end
