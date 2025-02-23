# frozen_string_literal: true

require "test_helper"

class NotTest < Minitest::Test
  def test_initialize # rubocop:disable Minitest/MultipleAssertions
    not_circuit = Logicuit::Not.new(1)

    assert not_circuit.a.current
    refute not_circuit.y.current

    not_circuit = Logicuit::Not.new(0)

    refute not_circuit.a.current
    assert not_circuit.y.current
  end

  def test_change_input_state # rubocop:disable Metrics/AbcSize,Minitest/MultipleAssertions
    not_circuit = Logicuit::Not.new(1)

    assert not_circuit.a.current
    refute not_circuit.y.current

    not_circuit.a.off

    refute not_circuit.a.current
    assert not_circuit.y.current

    not_circuit.a.on

    assert not_circuit.a.current
    refute not_circuit.y.current
  end
end
