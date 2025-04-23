# frozen_string_literal: true

require "test_helper"

class HalfAdderTest < Minitest::Test
  def test_half_adder
    assert_matches_truth_table(Logicuit::Circuits::Combinational::HalfAdder)
  end
end
