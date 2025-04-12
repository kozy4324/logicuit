# frozen_string_literal: true

require "test_helper"

class OneBitCpuTest < Minitest::Test
  def test_one_bit_cpu
    subject = Logicuit::Circuits::Sequential::OneBitCpu.new

    refute subject.y.current

    Logicuit::Signals::Clock.tick

    refute subject.y.current

    subject.a.on
    Logicuit::Signals::Clock.tick

    refute subject.y.current

    Logicuit::Signals::Clock.tick

    assert subject.y.current

    Logicuit::Signals::Clock.tick

    refute subject.y.current
  end
end
