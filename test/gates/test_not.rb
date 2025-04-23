# frozen_string_literal: true

require "test_helper"

class NotTest < Minitest::Test
  def test_not_gate
    assert_matches_truth_table(Logicuit::Gates::Not)
  end
end
