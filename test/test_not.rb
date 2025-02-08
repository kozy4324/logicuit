# frozen_string_literal: true

require "test_helper"

class TestNot < Minitest::Test
  def test_signal
    assert_equal [0], Logicuit::Not.new(1).signal.map(&:call)
    assert_equal [1], Logicuit::Not.new(0).signal.map(&:call)

    assert_equal [0], Logicuit::Not.new(-> { 1 }).signal.map(&:call)
    assert_equal [1], Logicuit::Not.new(-> { 0 }).signal.map(&:call)
  end
end
