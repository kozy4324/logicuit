# frozen_string_literal: true

require "test_helper"

class NotTest < Minitest::Test
  def test_initialize
    not_circuit = Logicuit::Not.new(1)
    assert_equal true, not_circuit.a.current
    assert_equal false, not_circuit.y.current

    not_circuit = Logicuit::Not.new(0)
    assert_equal false, not_circuit.a.current
    assert_equal true, not_circuit.y.current
  end
end
