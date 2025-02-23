# frozen_string_literal: true

require "test_helper"

class AndTest < Minitest::Test
  def test_initialize # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Minitest/MultipleAssertions
    and_circuit = Logicuit::And.new(1, 1)

    assert and_circuit.a.current
    assert and_circuit.b.current
    assert and_circuit.y.current

    and_circuit = Logicuit::And.new(1, 0)

    assert and_circuit.a.current
    refute and_circuit.b.current
    refute and_circuit.y.current

    and_circuit = Logicuit::And.new(0, 1)

    refute and_circuit.a.current
    assert and_circuit.b.current
    refute and_circuit.y.current

    and_circuit = Logicuit::And.new(0, 0)

    refute and_circuit.a.current
    refute and_circuit.b.current
    refute and_circuit.y.current
  end

  def test_change_input_state # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Minitest/MultipleAssertions
    and_circuit = Logicuit::And.new(1, 1)

    assert and_circuit.a.current
    assert and_circuit.b.current
    assert and_circuit.y.current

    and_circuit.a.off

    refute and_circuit.a.current
    assert and_circuit.b.current
    refute and_circuit.y.current

    and_circuit.a.on

    assert and_circuit.a.current
    assert and_circuit.b.current
    assert and_circuit.y.current

    and_circuit.b.off

    assert and_circuit.a.current
    refute and_circuit.b.current
    refute and_circuit.y.current

    and_circuit.a.off

    refute and_circuit.a.current
    refute and_circuit.b.current
    refute and_circuit.y.current

    and_circuit.a.on

    assert and_circuit.a.current
    refute and_circuit.b.current
    refute and_circuit.y.current

    and_circuit.b.on

    assert and_circuit.a.current
    assert and_circuit.b.current
    assert and_circuit.y.current
  end
end
