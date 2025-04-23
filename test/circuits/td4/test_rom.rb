# frozen_string_literal: true

require "test_helper"

class RomTest < Minitest::Test
  def test_rom_timer
    assert_matches_truth_table(Logicuit::Circuits::Td4::Rom)
  end
end
