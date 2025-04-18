# frozen_string_literal: true

require "test_helper"

class SignalGroupTest < Minitest::Test
  def test_signal_connects_to_signal_group
    s = Logicuit::Signals::Signal.new
    sg = Logicuit::Signals::SignalGroup.new(
      Logicuit::Signals::Signal.new,
      Logicuit::Signals::Signal.new
    )
    s >> sg
    refute sg.signals[0].current
    refute sg.signals[1].current
    s.on
    assert sg.signals[0].current
    assert sg.signals[1].current
  end

  def test_signal_connects_to_array_of_signals
    s = Logicuit::Signals::Signal.new
    ary = [
      Logicuit::Signals::Signal.new,
      Logicuit::Signals::Signal.new
    ]
    s >> ary
    refute ary[0].current
    refute ary[1].current
    s.on
    assert ary[0].current
    assert ary[1].current
  end

  def test_signal_group_connects_to_signal_group
    sg1 = Logicuit::Signals::SignalGroup.new(
      Logicuit::Signals::Signal.new,
      Logicuit::Signals::Signal.new
    )
    sg2 = Logicuit::Signals::SignalGroup.new(
      Logicuit::Signals::Signal.new,
      Logicuit::Signals::Signal.new
    )
    sg1 >> sg2
    refute sg2.signals[0].current
    refute sg2.signals[1].current
    sg1.signals[0].on
    assert sg2.signals[0].current
    refute sg2.signals[1].current
    sg1.signals[1].on
    assert sg2.signals[0].current
    assert sg2.signals[1].current
  end

  def test_signal_group_connects_to_array_of_signals
    sg = Logicuit::Signals::SignalGroup.new(
      Logicuit::Signals::Signal.new,
      Logicuit::Signals::Signal.new
    )
    ary = [
      Logicuit::Signals::Signal.new,
      Logicuit::Signals::Signal.new
    ]
    sg >> ary
    refute ary[0].current
    refute ary[1].current
    sg.signals[0].on
    assert ary[0].current
    refute ary[1].current
    sg.signals[1].on
    assert ary[0].current
    assert ary[1].current
  end

  using Logicuit::ArrayAsSignalGroup

  def test_array_of_signals_connects_to_signal_group
    ary = [
      Logicuit::Signals::Signal.new,
      Logicuit::Signals::Signal.new
    ]
    sg = Logicuit::Signals::SignalGroup.new(
      Logicuit::Signals::Signal.new,
      Logicuit::Signals::Signal.new
    )
    ary >> sg
    refute sg.signals[0].current
    refute sg.signals[1].current
    ary[0].on
    assert sg.signals[0].current
    refute sg.signals[1].current
    ary[1].on
    assert sg.signals[0].current
    assert sg.signals[1].current
  end

  def test_array_of_signals_connects_to_arryy_of_signals
    ary1 = [
      Logicuit::Signals::Signal.new,
      Logicuit::Signals::Signal.new
    ]
    ary2 = [
      Logicuit::Signals::Signal.new,
      Logicuit::Signals::Signal.new
    ]
    ary1 >> ary2
    refute ary2[0].current
    refute ary2[1].current
    ary1[0].on
    assert ary2[0].current
    refute ary2[1].current
    ary1[1].on
    assert ary2[0].current
    assert ary2[1].current
  end
end
