# frozen_string_literal: true

require "test_helper"

class SignalTest < Minitest::Test
  def test_signal_behavior
    signal = Logicuit::Signals::Signal.new(true)

    assert signal.current

    # ON -> ON
    signal.on

    assert signal.current

    # ON -> OFF
    signal.off

    refute signal.current

    # OFF -> OFF
    signal.off

    refute signal.current

    # OFF -> ON
    signal.on

    assert signal.current

    signal = Logicuit::Signals::Signal.new(false)

    refute signal.current
  end

  def test_connects_to
    signal = Logicuit::Signals::Signal.new(true)
    signal_other = Logicuit::Signals::Signal.new(false)

    refute signal_other.current

    signal >> signal_other

    assert signal.current
    assert signal_other.current

    signal.off

    refute signal.current
    refute signal_other.current

    signal.on

    assert signal.current
    assert signal_other.current
  end
end
