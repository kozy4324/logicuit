# frozen_string_literal: true

module Logicuit
  # Signal
  class Signal
    ON = 1
    OFF = 0

    def initialize(initial_state)
      @state = initial_state
    end

    def on?
      @state == ON
    end

    def off?
      !on?
    end

    def on
      changed = @state == OFF
      @state = ON
      changed
    end

    def off
      changed = @state == ON
      @state = OFF
      changed
    end
  end
end
