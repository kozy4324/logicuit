# frozen_string_literal: true

require "test_helper"

class XorTest < Minitest::Test
  def test_or_gate
    assert_matches_truth_table(Logicuit::Gates::Xor)
  end
end
