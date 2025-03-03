# frozen_string_literal: true

module Logicuit
  module Circuits
    module Combinational
      # A Multiplexer with 2 inputs and 1 output
      #
      # (C0)-|   |
      # (C1)-|MUX|--(Y)
      # (A)--|   |
      #
      # (C0)---------|
      #              |AND|--+
      #      +-|NOT|-|      +--|
      #      |                 |OR|--(Y)
      # (C1)---------|      +--|
      #      |       |AND|--+
      # (A)--+-------|
      #
      class Multiplexer2To1
        def initialize(c0 = 0, c1 = 0, a = 0) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Naming/MethodParameterName
          @c0 = Signals::Signal.new(c0 == 1)
          @c1 = Signals::Signal.new(c1 == 1)
          @a  = Signals::Signal.new(a == 1)
          @y = Signals::Signal.new(false)

          @not = Not.new
          @and0 = And.new
          @and1 = And.new
          @or   = Or.new

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
