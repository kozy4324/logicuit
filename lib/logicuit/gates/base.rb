# frozen_string_literal: true

module Logicuit
  module Gates
    # base class for all gates
    class Base
      def initialize(*args)
        define_inputs(*args)
        define_outputs
        evaluate
      end

      def evaluate
        raise NotImplementedError, "Subclasses must implement the evaluate method"
      end

      def self.define_inputs(*inputs) # rubocop:disable Metrics/MethodLength
        inputs.each do |input|
          define_method(input) do
            instance_variable_get("@#{input}")
          end
        end

        define_method(:define_inputs) do |*args|
          inputs.each_with_index do |input, index|
            signal = Signals::Signal.new(args[index] == 1)
            signal.on_change << self
            instance_variable_set("@#{input}", signal)
          end
        end
      end

      def self.define_outputs(*outputs)
        outputs.each do |output|
          define_method(output) do
            instance_variable_get("@#{output}")
          end
        end

        define_method(:define_outputs) do
          outputs.each do |output|
            instance_variable_set("@#{output}", Signals::Signal.new(false))
          end
        end
      end
    end
  end
end
