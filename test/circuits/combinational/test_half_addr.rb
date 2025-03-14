# frozen_string_literal: true

require "test_helper"

class HalfAdderTest < Minitest::Test
  def test_multiplexer2to1
    assert_as_truth_table(Logicuit::Circuits::Combinational::HalfAdder)
    assert_behavior_against_truth_table(Logicuit::Circuits::Combinational::HalfAdder)
  end
end
