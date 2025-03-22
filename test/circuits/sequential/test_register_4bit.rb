# frozen_string_literal: true

require "test_helper"

class Register4bitTest < Minitest::Test
  def test_register_4bit
    assert_as_truth_table(Logicuit::Circuits::Sequential::Register4bit)
    assert_behavior_against_truth_table(Logicuit::Circuits::Sequential::Register4bit)
  end
end
