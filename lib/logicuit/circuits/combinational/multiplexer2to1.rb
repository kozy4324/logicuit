# frozen_string_literal: true

module Logicuit
  module Circuits
    module Combinational
      # A Multiplexer with 2 inputs and 1 output
      #
      # (C0)---------|
      #              |AND|--+
      #      +-|NOT|-|      +--|
      #      |                 |OR|--(Y)
      # (C1)---------|      +--|
      #      |       |AND|--+
      # (A)--+-------|
      #
      # C0 | C1 | A | Y
      # ---+----+---+---
      #  0 |  x | 0 | 0
      #  1 |  x | 0 | 1
      #  x |  0 | 1 | 0
      #  x |  1 | 1 | 1
      #
      class Multiplexer2To1
        def initialize(c0 = 0, c1 = 0, a = 0) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Naming/MethodParameterName
          @c0 = Signals::Signal.new(c0 == 1)
          @c1 = Signals::Signal.new(c1 == 1)
          @a  = Signals::Signal.new(a == 1)
          @y  = Signals::Signal.new(false)

          @not  = Gates::Not.new
          @and0 = Gates::And.new
          @and1 = Gates::And.new
          @or   = Gates::Or.new

          @c0     >> @and0.a
          @c1     >> @and1.a
          @a      >> @not.a
          @not.y  >> @and0.b
          @a      >> @and1.b
          @and0.y >> @or.a
          @and1.y >> @or.b
          @or.y   >> @y
        end

        attr_reader :c0, :c1, :a, :y
      end
    end
  end
end
