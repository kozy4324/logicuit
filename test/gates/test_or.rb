# frozen_string_literal: true

require "test_helper"

class OrTest < Minitest::Test
  def test_initialize # rubocop:disable Metrics/MethodLength
    test_cases = [
      [1, 1, true, true, true],
      [1, 0, true, false, true],
      [0, 1, false, true, true],
      [0, 0, false, false, false]
    ]

    test_cases.each do |input_a, input_b, a, b, y|
      and_gate = Logicuit::Gates::Or.new(input_a, input_b)

      assert_equal a, and_gate.a.current, "Or.new(#{input_a}, #{input_b}).a should be #{a}"
      assert_equal b, and_gate.b.current, "Or.new(#{input_a}, #{input_b}).b should be #{b}"
      assert_equal y, and_gate.y.current, "Or.new(#{input_a}, #{input_b}).y should be #{y}"
    end
  end

  def test_change_input_state # rubocop:disable Metrics/MethodLength
    or_gate = Logicuit::Gates::Or.new(1, 1)

    test_cases = [
      [:a, :off, false, true, true],
      [:a, :on, true, true, true],
      [:b, :off, true, false, true],
      [:a, :off, false, false, false],
      [:a, :on, true, false, true],
      [:b, :on, true, true, true]
    ]

    test_cases.each do |input, state, a, b, y|
      or_gate.send(input).send(state)

      assert_equal a, or_gate.a.current, "or_gate.#{input}.#{state} should set a to #{a}"
      assert_equal b, or_gate.b.current, "or_gate.#{input}.#{state} should set b to #{b}"
      assert_equal y, or_gate.y.current, "or_gate.#{input}.#{state} should set y to #{y}"
    end
  end
end
