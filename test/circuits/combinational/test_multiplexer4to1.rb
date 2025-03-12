# frozen_string_literal: true

require "test_helper"

class Multiplexer4To1Test < Minitest::Test
  def test_multiplexer4to1
    assert_as_truth_table(Logicuit::Circuits::Combinational::Multiplexer4To1)
    assert_behavior_against_truth_table(Logicuit::Circuits::Combinational::Multiplexer4To1)
  end
end
