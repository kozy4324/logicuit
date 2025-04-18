# frozen_string_literal: true

require "test_helper"

class Td4CpuTest < Minitest::Test
  def test_td4_cpu
    subject = Logicuit::Circuits::Td4::Cpu.new[:led1, :led2, :led3, :led4]
    assert_equal "0000", subject.to_s

    Logicuit::Signals::Clock.tick
    assert_equal "0111", subject.to_s

    64.times { Logicuit::Signals::Clock.tick }
    assert_equal "0111", subject.to_s

    Logicuit::Signals::Clock.tick
    assert_equal "0110", subject.to_s

    64.times { Logicuit::Signals::Clock.tick }
    assert_equal "0110", subject.to_s

    16.times do
      Logicuit::Signals::Clock.tick
      assert_equal "0000", subject.to_s

      Logicuit::Signals::Clock.tick
      assert_equal "0100", subject.to_s

      Logicuit::Signals::Clock.tick
      assert_equal "0100", subject.to_s

      Logicuit::Signals::Clock.tick
      assert_equal "0100", subject.to_s
    end

    Logicuit::Signals::Clock.tick
    assert_equal "1000", subject.to_s

    10.times do
      Logicuit::Signals::Clock.tick
      assert_equal "1000", subject.to_s
    end
  end
end
