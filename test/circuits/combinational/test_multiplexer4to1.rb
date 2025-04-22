# frozen_string_literal: true

require "test_helper"

class Multiplexer4to1Test < Minitest::Test
  def test_multiplexer4to1
    assert_as_truth_table(Logicuit::Circuits::Combinational::Multiplexer4to1)
  end
end
