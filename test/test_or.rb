# frozen_string_literal: true

require "test_helper"

class OrTest < Minitest::Test
  def test_signal # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    assert_equal [1], Logicuit::Or.new(1, 1).signal.map(&:call)
    assert_equal [1], Logicuit::Or.new(1, 0).signal.map(&:call)
    assert_equal [1], Logicuit::Or.new(0, 1).signal.map(&:call)
    assert_equal [0], Logicuit::Or.new(0, 0).signal.map(&:call)

    assert_equal [1], Logicuit::Or.new(-> { 1 }, -> { 1 }).signal.map(&:call)
    assert_equal [1], Logicuit::Or.new(-> { 1 }, -> { 0 }).signal.map(&:call)
    assert_equal [1], Logicuit::Or.new(-> { 0 }, -> { 1 }).signal.map(&:call)
    assert_equal [0], Logicuit::Or.new(-> { 0 }, -> { 0 }).signal.map(&:call)
  end
end
