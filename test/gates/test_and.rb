# frozen_string_literal: true

require "test_helper"

class AndTest < Minitest::Test
  def test_initialize
    assert_as_truth_table(Logicuit::Gates::And)
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

      assert_equal a, and_gate.a.current, "and_gate.#{input}.#{state} should set a to #{a}"
      assert_equal b, and_gate.b.current, "and_gate.#{input}.#{state} should set b to #{b}"
      assert_equal y, and_gate.y.current, "and_gate.#{input}.#{state} should set y to #{y}"
    end
  end
end
