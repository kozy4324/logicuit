# frozen_string_literal: true

require "test_helper"

class AndTest < Minitest::Test
  def test_initialize # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Minitest/MultipleAssertions
    and_gate = Logicuit::And.new(1, 1)

    assert and_gate.a.current
    assert and_gate.b.current
    assert and_gate.y.current

    and_gate = Logicuit::And.new(1, 0)

    assert and_gate.a.current
    refute and_gate.b.current
    refute and_gate.y.current

    and_gate = Logicuit::And.new(0, 1)

    refute and_gate.a.current
    assert and_gate.b.current
    refute and_gate.y.current

    and_gate = Logicuit::And.new(0, 0)

    refute and_gate.a.current
    refute and_gate.b.current
    refute and_gate.y.current
  end

  def test_change_input_state # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Minitest/MultipleAssertions
    and_gate = Logicuit::And.new(1, 1)

    assert and_gate.a.current
    assert and_gate.b.current
    assert and_gate.y.current

    and_gate.a.off

    refute and_gate.a.current
    assert and_gate.b.current
    refute and_gate.y.current

    and_gate.a.on

    assert and_gate.a.current
    assert and_gate.b.current
    assert and_gate.y.current

    and_gate.b.off

    assert and_gate.a.current
    refute and_gate.b.current
    refute and_gate.y.current

    and_gate.a.off

    refute and_gate.a.current
    refute and_gate.b.current
    refute and_gate.y.current

    and_gate.a.on

    assert and_gate.a.current
    refute and_gate.b.current
    refute and_gate.y.current

    and_gate.b.on

    assert and_gate.a.current
    assert and_gate.b.current
    assert and_gate.y.current
  end
end
