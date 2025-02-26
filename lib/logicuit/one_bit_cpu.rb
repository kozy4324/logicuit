# frozen_string_literal: true

module Logicuit
  # 1 bit CPU
  #
  #  +-(Y)-|NOT|-(A)-+
  #  |               |
  #  +-(D)-|   |-(Q)-+
  #        |DFF|
  #   (CK)-|>  |
  #
  class OneBitCpu
    def initialize(ck = nil) # rubocop:disable Naming/MethodParameterName
      @dff = Logicuit::DFlipFlop.new(ck)
      @not = Logicuit::Not.new
      @dff.q >> @not.a
      @not.y >> @dff.d
    end

    def ck
      @dff.ck
    end

    def to_s
      <<~CIRCUIT
        +-(#{@not.y})-|NOT|-(#{@not.a})-+
        |               |
        +-(#{@dff.d})-|   |-(#{@dff.q})-+
              |DFF|
         (CK)-|>  |
      CIRCUIT
    end

    def self.run
      obc = new
      loop do
        system("clear")
        puts obc
        sleep 1
        obc.ck.tick
      end
    end
  end
end
