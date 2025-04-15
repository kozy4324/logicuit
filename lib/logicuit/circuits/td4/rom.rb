# frozen_string_literal: true

module Logicuit
  module Circuits
    module Td4
      # Timer
      class Rom < DSL
        define_inputs :a3, :a2, :a1, :a0

        define_outputs :d7, :d6, :d5, :d4, :d3, :d2, :d1, :d0

        def evaluate
          return unless initialized

          output = case "#{a3}#{a2}#{a1}#{a0}"
                   in "0000" then "10110111"
                   in "0001" then "00000001"
                   in "0010" then "11100001"
                   in "0011" then "00000001"
                   in "0100" then "11100011"
                   in "0101" then "10110110"
                   in "0110" then "00000001"
                   in "0111" then "11100110"
                   in "1000" then "00000001"
                   in "1001" then "11101000"
                   in "1010" then "10110000"
                   in "1011" then "10110100"
                   in "1100" then "00000001"
                   in "1101" then "11101010"
                   in "1110" then "10111000"
                   in "1111" then "11111111"
                   end
          output.split("").zip([d7, d6, d5, d4, d3, d2, d1, d0]).each do |v, o|
            v == "1" ? o.on : o.off
          end
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
