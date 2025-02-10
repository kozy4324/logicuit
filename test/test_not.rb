# frozen_string_literal: true

require "test_helper"

class NotTest < Minitest::Test
  def test_signal # rubocop:disable Metrics/AbcSize
    assert_equal [0], Logicuit::Not.new(1).signal.map(&:call)
    assert_equal [1], Logicuit::Not.new(0).signal.map(&:call)

    assert_equal [0], Logicuit::Not.new(-> { 1 }).signal.map(&:call)
    assert_equal [1], Logicuit::Not.new(-> { 0 }).signal.map(&:call)
  end
end
