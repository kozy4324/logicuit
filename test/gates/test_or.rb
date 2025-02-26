# frozen_string_literal: true

require "test_helper"

class OrTest < Minitest::Test
  def test_initialize # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Minitest/MultipleAssertions
    or_gate = Logicuit::Gates::Or.new(1, 1)

    assert or_gate.a.current
    assert or_gate.b.current
    assert or_gate.y.current

    or_gate = Logicuit::Gates::Or.new(1, 0)

    assert or_gate.a.current
    refute or_gate.b.current
    assert or_gate.y.current

    or_gate = Logicuit::Gates::Or.new(0, 1)

    refute or_gate.a.current
    assert or_gate.b.current
    assert or_gate.y.current

    or_gate = Logicuit::Gates::Or.new(0, 0)

    refute or_gate.a.current
    refute or_gate.b.current
    refute or_gate.y.current
  end

  def test_change_input_state # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Minitest/MultipleAssertions
    or_gate = Logicuit::Gates::Or.new(1, 1)

    assert or_gate.a.current
    assert or_gate.b.current
    assert or_gate.y.current

    or_gate.a.off

    refute or_gate.a.current
    assert or_gate.b.current
    assert or_gate.y.current

    or_gate.a.on

    assert or_gate.a.current
    assert or_gate.b.current
    assert or_gate.y.current

    or_gate.b.off

    assert or_gate.a.current
    refute or_gate.b.current
    assert or_gate.y.current

    or_gate.a.off

    refute or_gate.a.current
    refute or_gate.b.current
    refute or_gate.y.current

    or_gate.a.on

    assert or_gate.a.current
    refute or_gate.b.current
    assert or_gate.y.current

    or_gate.b.on

    assert or_gate.a.current
    assert or_gate.b.current
    assert or_gate.y.current
  end
end
