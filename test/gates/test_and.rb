# frozen_string_literal: true

require "test_helper"

class AndTest < Minitest::Test
  def test_and_gate
    assert_matches_truth_table(Logicuit::Gates::And)
  end
end
