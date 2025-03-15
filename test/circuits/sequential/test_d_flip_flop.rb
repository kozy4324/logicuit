# frozen_string_literal: true

require "test_helper"

class DFlipFlopTest < Minitest::Test
  def test_initialize
    d_flip_flop = Logicuit::Circuits::Sequential::DFlipFlop.new(0)

    refute d_flip_flop.q.current

    d_flip_flop = Logicuit::Circuits::Sequential::DFlipFlop.new(1)

    assert d_flip_flop.q.current
  end

  def test_tick # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Minitest/MultipleAssertions
    d_flip_flop = Logicuit::Circuits::Sequential::DFlipFlop.new

    refute d_flip_flop.q.current

    Logicuit::Signals::Clock.tick

    refute d_flip_flop.q.current

    d_flip_flop.d.on

    refute d_flip_flop.q.current

    Logicuit::Signals::Clock.tick

    assert d_flip_flop.q.current

    d_flip_flop.d.off

    assert d_flip_flop.q.current

    Logicuit::Signals::Clock.tick

    refute d_flip_flop.q.current
  end
end
