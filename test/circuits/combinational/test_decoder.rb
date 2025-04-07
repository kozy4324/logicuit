# frozen_string_literal: true

require "test_helper"

class DecoderTest < Minitest::Test
  def test_docoder
    assert_as_truth_table(Logicuit::Circuits::Combinational::Decoder)
    assert_behavior_against_truth_table(Logicuit::Circuits::Combinational::Decoder)
  end
end
