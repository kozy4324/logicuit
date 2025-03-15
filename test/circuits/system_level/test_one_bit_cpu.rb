# frozen_string_literal: true

require "test_helper"

class OneBitCpuTest < Minitest::Test
  def test_one_bit_cpu
    subject = Logicuit::Circuits::SystemLevel::OneBitCpu.new

    refute subject.y.current

    Logicuit::Signals::Clock.tick

    assert subject.y.current

    Logicuit::Signals::Clock.tick

    refute subject.y.current
  end
end
