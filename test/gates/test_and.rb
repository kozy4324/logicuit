# frozen_string_literal: true

require "test_helper"

class AndTest < Minitest::Test
  def test_and_gate
    assert_as_truth_table(Logicuit::Gates::And)
    assert_behavior_against_truth_table(Logicuit::Gates::And)
  end
end
