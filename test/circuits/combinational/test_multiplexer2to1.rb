# frozen_string_literal: true

require "test_helper"

class Multiplexer2To1Test < Minitest::Test
  def test_initialize
    assert_as_truth_table(Logicuit::Circuits::Combinational::Multiplexer2To1)
  end

  def test_change_input_state # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Minitest/MultipleAssertions
    mux = Logicuit::Circuits::Combinational::Multiplexer2To1.new(0, 0, 0)

    test_cases = [
      { target: :c0, method: :on,  c0: true,  c1: false, a: false, y: true  },
      { target: :a,  method: :on,  c0: true,  c1: false, a: true,  y: false },
      { target: :c1, method: :on,  c0: true,  c1: true,  a: true,  y: true  },
      { target: :c0, method: :off, c0: false, c1: true,  a: true,  y: true  },
      { target: :a,  method: :off, c0: false, c1: true,  a: false, y: false },
      { target: :c1, method: :off, c0: false, c1: false, a: false, y: false }
    ]

    test_cases.each do |test_case|
      target, method, c0, c1, a, y = test_case.values_at(:target, :method, :c0, :c1, :a, :y)

      mux.send(target).send(method)

      assert_equal c0, mux.c0.current, "mux.#{target}.#{method} should set c0 to #{c0}"
      assert_equal c1, mux.c1.current, "mux.#{target}.#{method} should set c1 to #{c1}"
      assert_equal a, mux.a.current, "mux.#{target}.#{method} should set a to #{a}"
      assert_equal y, mux.y.current, "mux.#{target}.#{method} should set y to #{y}"
    end
  end
end
