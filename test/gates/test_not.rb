# frozen_string_literal: true

require "test_helper"

class NotTest < Minitest::Test
  def test_initialize
    test_cases = [
      [1, true, false],
      [0, false, true]
    ]

    test_cases.each do |input_a, a, y|
      not_gate = Logicuit::Gates::Not.new(input_a)

      assert_equal a, not_gate.a.current
      assert_equal y, not_gate.y.current
    end
  end

  def test_change_input_state
    not_gate = Logicuit::Gates::Not.new(1, 1)

    test_cases = [
      [:a, :off, false, true],
      [:a, :on, true, false]
    ]

    test_cases.each do |input, state, a, y|
      not_gate.send(input).send(state)

      assert_equal a, not_gate.a.current
      assert_equal y, not_gate.y.current
    end
  end
end
