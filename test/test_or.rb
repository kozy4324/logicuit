# frozen_string_literal: true

require "test_helper"

class TestOr < Minitest::Test
  def test_signal # rubocop:disable Metrics/AbcSize
    assert_equal [1], Logicuit::Or.new(1, 1).signal
    assert_equal [1], Logicuit::Or.new(1, 0).signal
    assert_equal [1], Logicuit::Or.new(0, 1).signal
    assert_equal [0], Logicuit::Or.new(0, 0).signal

    assert_equal [1], Logicuit::Or.new(-> { 1 }, -> { 1 }).signal
    assert_equal [1], Logicuit::Or.new(-> { 1 }, -> { 0 }).signal
    assert_equal [1], Logicuit::Or.new(-> { 0 }, -> { 1 }).signal
    assert_equal [0], Logicuit::Or.new(-> { 0 }, -> { 0 }).signal
  end
end
