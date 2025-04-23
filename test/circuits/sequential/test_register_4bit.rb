# frozen_string_literal: true

require "test_helper"

class Register4bitTest < Minitest::Test
  def test_register_4bit
    assert_matches_truth_table(Logicuit::Circuits::Sequential::Register4bit)
  end
end
