# frozen_string_literal: true

require "test_helper"

class RomTest < Minitest::Test
  def test_rom_timer
    assert_as_truth_table(Logicuit::Circuits::Td4::Rom)
    assert_behavior_against_truth_table(Logicuit::Circuits::Td4::Rom)
  end
end
