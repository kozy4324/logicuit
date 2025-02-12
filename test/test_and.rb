# frozen_string_literal: true

require "test_helper"

class AndTest < Minitest::Test
  def test_initialize # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    and_circuit = Logicuit::And.new(1, 1)
    assert_equal true, and_circuit.a.current
    assert_equal true, and_circuit.b.current
    assert_equal true, and_circuit.y.current

    and_circuit = Logicuit::And.new(1, 0)
    assert_equal true, and_circuit.a.current
    assert_equal false, and_circuit.b.current
    assert_equal false, and_circuit.y.current

    and_circuit = Logicuit::And.new(0, 1)
    assert_equal false, and_circuit.a.current
    assert_equal true, and_circuit.b.current
    assert_equal false, and_circuit.y.current

    and_circuit = Logicuit::And.new(0, 0)
    assert_equal false, and_circuit.a.current
    assert_equal false, and_circuit.b.current
    assert_equal false, and_circuit.y.current
  end

  def test_change_input_state # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    and_circuit = Logicuit::And.new(1, 1)
    assert_equal true, and_circuit.a.current
    assert_equal true, and_circuit.b.current
    assert_equal true, and_circuit.y.current

    and_circuit.a.off
    assert_equal false, and_circuit.a.current
    assert_equal true, and_circuit.b.current
    assert_equal false, and_circuit.y.current

    and_circuit.a.on
    assert_equal true, and_circuit.a.current
    assert_equal true, and_circuit.b.current
    assert_equal true, and_circuit.y.current

    and_circuit.b.off
    assert_equal true, and_circuit.a.current
    assert_equal false, and_circuit.b.current
    assert_equal false, and_circuit.y.current

    and_circuit.a.off
    assert_equal false, and_circuit.a.current
    assert_equal false, and_circuit.b.current
    assert_equal false, and_circuit.y.current

    and_circuit.a.on
    assert_equal true, and_circuit.a.current
    assert_equal false, and_circuit.b.current
    assert_equal false, and_circuit.y.current

    and_circuit.b.on
    assert_equal true, and_circuit.a.current
    assert_equal true, and_circuit.b.current
    assert_equal true, and_circuit.y.current
  end
end
