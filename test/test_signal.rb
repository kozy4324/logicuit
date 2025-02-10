# frozen_string_literal: true

require "test_helper"

class SignalTest < Minitest::Test
  def test_signal_behavior # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    signal = Logicuit::Signal.new(Logicuit::Signal::ON)
    assert_equal true, signal.on?
    assert_equal false, signal.off?

    # ON -> ON
    assert_equal false, signal.on
    assert_equal true, signal.on?
    assert_equal false, signal.off?

    # ON -> OFF
    assert_equal true, signal.off
    assert_equal false, signal.on?
    assert_equal true, signal.off?

    # OFF -> OFF
    assert_equal false, signal.off
    assert_equal false, signal.on?
    assert_equal true, signal.off?

    # OFF -> ON
    assert_equal true, signal.on
    assert_equal true, signal.on?
    assert_equal false, signal.off?

    signal = Logicuit::Signal.new(Logicuit::Signal::OFF)
    assert_equal false, signal.on?
    assert_equal true, signal.off?
  end
end
