# frozen_string_literal: true

module Logicuit
  module Circuits
    module Combinational
      # FullAdder class
      class FullAdder4bit < Base
        diagram <<~DIAGRAM
          (Cin)-|    |--(S0)  +--------|    |--(S1)
          (A0)--|FADD|        |  (A1)--|FADD|
          (B0)--|    |--------+  (B1)--|    |--+
                                               |
             +---------------------------------+
             |
             +--|    |--(S2)  +--------|    |--(S3)
          (A2)--|FADD|        |  (A3)--|FADD|
          (B2)--|    |--------+  (B3)--|    |---(C)
        DIAGRAM

        define_inputs :cin, :a0, :b0, :a1, :b1, :a2, :b2, :a3, :b3

        define_outputs :s0, :s1, :s2, :s3, :c

        assembling do |cin, a0, b0, a1, b1, a2, b2, a3, b3, s0, s1, s2, s3, cout|
          [[a0, b0, s0], [a1, b1, s1], [a2, b2, s2], [a3, b3, s3]].reduce(cin) do |c, sigs|
            a, b, s = sigs
            full_addr = Combinational::FullAdder.new
            c >> full_addr.cin
            a >> full_addr.a
            b >> full_addr.b
            full_addr.s >> s
            full_addr.c
          end >> cout
        end
      end
    end
  end
end
