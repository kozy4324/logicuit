# frozen_string_literal: true

require "test_helper"

class NandTest < Minitest::Test
  def test_nand_gate
    assert_as_truth_table(Logicuit::Gates::Nand)
    assert_behavior_against_truth_table(Logicuit::Gates::Nand)
  end
end
