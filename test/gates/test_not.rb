# frozen_string_literal: true

require "test_helper"

class NotTest < Minitest::Test
  def test_not_gate
    assert_as_truth_table(Logicuit::Gates::Not)
    assert_behavior_against_truth_table(Logicuit::Gates::Not)
  end
end
