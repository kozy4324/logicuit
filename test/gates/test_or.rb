# frozen_string_literal: true

require "test_helper"

class OrTest < Minitest::Test
  def test_or_gate
    assert_as_truth_table(Logicuit::Gates::Or)
  end
end
