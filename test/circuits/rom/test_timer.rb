# frozen_string_literal: true

require "test_helper"

class RomTimerTest < Minitest::Test
  def test_rom_timer
    assert_as_truth_table(Logicuit::Circuits::Rom::Timer)
    assert_behavior_against_truth_table(Logicuit::Circuits::Rom::Timer)
  end
end
