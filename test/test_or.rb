# frozen_string_literal: true

require "test_helper"

class OrTest < Minitest::Test
  def test_initialize # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    or_circuit = Logicuit::Or.new(1, 1)
    assert_equal true, or_circuit.a.current
    assert_equal true, or_circuit.b.current
    assert_equal true, or_circuit.y.current

    or_circuit = Logicuit::Or.new(1, 0)
    assert_equal true, or_circuit.a.current
    assert_equal false, or_circuit.b.current
    assert_equal true, or_circuit.y.current

    or_circuit = Logicuit::Or.new(0, 1)
    assert_equal false, or_circuit.a.current
    assert_equal true, or_circuit.b.current
    assert_equal true, or_circuit.y.current

    or_circuit = Logicuit::Or.new(0, 0)
    assert_equal false, or_circuit.a.current
    assert_equal false, or_circuit.b.current
    assert_equal false, or_circuit.y.current
  end

  def test_change_input_state # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    or_circuit = Logicuit::Or.new(1, 1)
    assert_equal true, or_circuit.a.current
    assert_equal true, or_circuit.b.current
    assert_equal true, or_circuit.y.current

    or_circuit.a.off
    assert_equal false, or_circuit.a.current
    assert_equal true, or_circuit.b.current
    assert_equal true, or_circuit.y.current

    or_circuit.a.on
    assert_equal true, or_circuit.a.current
    assert_equal true, or_circuit.b.current
    assert_equal true, or_circuit.y.current

    or_circuit.b.off
    assert_equal true, or_circuit.a.current
    assert_equal false, or_circuit.b.current
    assert_equal true, or_circuit.y.current

    or_circuit.a.off
    assert_equal false, or_circuit.a.current
    assert_equal false, or_circuit.b.current
    assert_equal false, or_circuit.y.current

    or_circuit.a.on
    assert_equal true, or_circuit.a.current
    assert_equal false, or_circuit.b.current
    assert_equal true, or_circuit.y.current

    or_circuit.b.on
    assert_equal true, or_circuit.a.current
    assert_equal true, or_circuit.b.current
    assert_equal true, or_circuit.y.current
  end
end
