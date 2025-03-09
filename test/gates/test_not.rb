# frozen_string_literal: true

require "test_helper"

class NotTest < Minitest::Test
  def test_initialize
    assert_as_truth_table(Logicuit::Gates::Not)
  end

  def test_change_input_state
    not_gate = Logicuit::Gates::Not.new(1, 1)

    test_cases = [
      [:a, :off, false, true],
      [:a, :on, true, false]
    ]

    test_cases.each do |input, state, a, y|
      not_gate.send(input).send(state)

      assert_equal a, not_gate.a.current, "not_gate.#{input}.#{state} should set a to #{a}"
      assert_equal y, not_gate.y.current, "not_gate.#{input}.#{state} should set y to #{y}"
    end
  end
end
