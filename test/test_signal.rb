# frozen_string_literal: true

require "test_helper"

class SignalTest < Minitest::Test
  def test_signal_behavior # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    signal = Logicuit::Signal.new(true)
    assert_equal true, signal.current

    # ON -> ON
    signal.on
    assert_equal true, signal.current

    # ON -> OFF
    signal.off
    assert_equal false, signal.current

    # OFF -> OFF
    signal.off
    assert_equal false, signal.current

    # OFF -> ON
    signal.on
    assert_equal true, signal.current

    signal = Logicuit::Signal.new(false)
    assert_equal false, signal.current
  end
end
