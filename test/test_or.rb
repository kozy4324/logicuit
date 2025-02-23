# frozen_string_literal: true

require "test_helper"

class OrTest < Minitest::Test
  def test_initialize # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Minitest/MultipleAssertions
    or_circuit = Logicuit::Or.new(1, 1)

    assert or_circuit.a.current
    assert or_circuit.b.current
    assert or_circuit.y.current

    or_circuit = Logicuit::Or.new(1, 0)

    assert or_circuit.a.current
    refute or_circuit.b.current
    assert or_circuit.y.current

    or_circuit = Logicuit::Or.new(0, 1)

    refute or_circuit.a.current
    assert or_circuit.b.current
    assert or_circuit.y.current

    or_circuit = Logicuit::Or.new(0, 0)

    refute or_circuit.a.current
    refute or_circuit.b.current
    refute or_circuit.y.current
  end

  def test_change_input_state # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Minitest/MultipleAssertions
    or_circuit = Logicuit::Or.new(1, 1)

    assert or_circuit.a.current
    assert or_circuit.b.current
    assert or_circuit.y.current

    or_circuit.a.off

    refute or_circuit.a.current
    assert or_circuit.b.current
    assert or_circuit.y.current

    or_circuit.a.on

    assert or_circuit.a.current
    assert or_circuit.b.current
    assert or_circuit.y.current

    or_circuit.b.off

    assert or_circuit.a.current
    refute or_circuit.b.current
    assert or_circuit.y.current

    or_circuit.a.off

    refute or_circuit.a.current
    refute or_circuit.b.current
    refute or_circuit.y.current

    or_circuit.a.on

    assert or_circuit.a.current
    refute or_circuit.b.current
    assert or_circuit.y.current

    or_circuit.b.on

    assert or_circuit.a.current
    assert or_circuit.b.current
    assert or_circuit.y.current
  end
end
