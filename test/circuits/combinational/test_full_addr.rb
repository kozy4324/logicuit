# frozen_string_literal: true

require "test_helper"

class FullAdderTest < Minitest::Test
  def test_full_adder
    assert_as_truth_table(Logicuit::Circuits::Combinational::FullAdder)
  end
end
