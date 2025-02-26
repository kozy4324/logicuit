# frozen_string_literal: true

require "test_helper"

class NotTest < Minitest::Test
  def test_initialize # rubocop:disable Minitest/MultipleAssertions
    not_gate = Logicuit::Gates::Not.new(1)

    assert not_gate.a.current
    refute not_gate.y.current

    not_gate = Logicuit::Gates::Not.new(0)

    refute not_gate.a.current
    assert not_gate.y.current
  end

  def test_change_input_state # rubocop:disable Metrics/AbcSize,Minitest/MultipleAssertions
    not_gate = Logicuit::Gates::Not.new(1)

    assert not_gate.a.current
    refute not_gate.y.current

    not_gate.a.off

    refute not_gate.a.current
    assert not_gate.y.current

    not_gate.a.on

    assert not_gate.a.current
    refute not_gate.y.current
  end
end
