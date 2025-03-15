# frozen_string_literal: true

require "test_helper"

class DFlipFlopTest < Minitest::Test
  def test_d_flip_flop
    assert_as_truth_table(Logicuit::Circuits::Sequential::DFlipFlop)
    assert_behavior_against_truth_table(Logicuit::Circuits::Sequential::DFlipFlop)
  end
end
