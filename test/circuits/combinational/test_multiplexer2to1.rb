# frozen_string_literal: true

require "test_helper"

class Multiplexer2To1Test < Minitest::Test
  def test_multiplexer2to1
    assert_as_truth_table(Logicuit::Circuits::Combinational::Multiplexer2To1)
    assert_behavior_against_truth_table(Logicuit::Circuits::Combinational::Multiplexer2To1)
  end
end
