# frozen_string_literal: true

require "test_helper"

class AndTest < Minitest::Test
  def test_initialize # rubocop:disable Metrics/MethodLength
    test_cases = [
      [1, 1, true, true, true],
      [1, 0, true, false, false],
      [0, 1, false, true, false],
      [0, 0, false, false, false]
    ]

    test_cases.each do |input_a, input_b, a, b, y|
      and_gate = Logicuit::Gates::And.new(input_a, input_b)

      assert_equal a, and_gate.a.current
      assert_equal b, and_gate.b.current
      assert_equal y, and_gate.y.current
    end
  end

  def test_change_input_state # rubocop:disable Metrics/MethodLength
    and_gate = Logicuit::Gates::And.new(1, 1)

    test_cases = [
      [:a, :off, false, true, false],
      [:a, :on, true, true, true],
      [:b, :off, true, false, false],
      [:a, :off, false, false, false],
      [:a, :on, true, false, false],
      [:b, :on, true, true, true]
    ]

    test_cases.each do |input, state, a, b, y|
      and_gate.send(input).send(state)

      assert_equal a, and_gate.a.current
      assert_equal b, and_gate.b.current
      assert_equal y, and_gate.y.current
    end
  end
end
