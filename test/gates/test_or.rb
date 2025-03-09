# frozen_string_literal: true

require "test_helper"

class OrTest < Minitest::Test
  def test_initialize
    assert_as_truth_table(Logicuit::Gates::Or)
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
