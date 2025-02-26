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
    def initialize
      @dff = Logicuit::DFlipFlop.new
      @not = Logicuit::Not.new
      @dff.q >> @not.a
      @not.y >> @dff.d
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
        Logicuit::Clock.tick
      end
    end
  end
end
