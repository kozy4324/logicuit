# frozen_string_literal: true

require "test_helper"

class Multiplexer2to1Test < Minitest::Test
  def test_multiplexer2to1
    assert_matches_truth_table(Logicuit::Circuits::Combinational::Multiplexer2to1)
  end
end
