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
      @dff = Logicuit::DFlipFlop.new(0, ck)
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
  end
end
