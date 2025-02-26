# frozen_string_literal: true

require "test_helper"

class DFlipFlopTest < Minitest::Test
  def test_initialize
    d_flip_flop = Logicuit::DFlipFlop.new(0)

    refute d_flip_flop.q.current

    d_flip_flop = Logicuit::DFlipFlop.new(1)

    assert d_flip_flop.q.current
  end

  def test_tick # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Minitest/MultipleAssertions
    signal = Logicuit::Signals::Signal.new(false)
    d_flip_flop = Logicuit::DFlipFlop.new(signal)

    refute d_flip_flop.q.current

    Logicuit::Signals::Clock.tick

    refute d_flip_flop.q.current

    signal.on

    refute d_flip_flop.q.current

    Logicuit::Signals::Clock.tick

    assert d_flip_flop.q.current

    signal.off

    assert d_flip_flop.q.current

    Logicuit::Signals::Clock.tick

    refute d_flip_flop.q.current
  end
end
