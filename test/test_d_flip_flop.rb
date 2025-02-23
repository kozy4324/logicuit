# frozen_string_literal: true

require "test_helper"

class DFlipFlopTest < Minitest::Test
  def test_initialize
    clock = Logicuit::Clock.new

    d_flip_flop = Logicuit::DFlipFlop.new(0, clock)

    refute d_flip_flop.q.current

    d_flip_flop = Logicuit::DFlipFlop.new(1, clock)

    assert d_flip_flop.q.current
  end

  def test_tick # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Minitest/MultipleAssertions
    clock = Logicuit::Clock.new
    signal = Logicuit::Signal.new(false)
    d_flip_flop = Logicuit::DFlipFlop.new(signal, clock)

    refute d_flip_flop.q.current

    clock.tick

    refute d_flip_flop.q.current

    signal.on

    refute d_flip_flop.q.current

    clock.tick

    assert d_flip_flop.q.current

    signal.off

    assert d_flip_flop.q.current

    clock.tick

    refute d_flip_flop.q.current
  end
end
