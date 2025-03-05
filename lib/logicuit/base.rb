# frozen_string_literal: true

module Logicuit
  # base class for all gates and circuits
  class Base
    def initialize(*args)
      @input_targets = []
      @output_targets = []
      define_inputs(*args)
      define_outputs
      evaluate
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
          @input_targets << input
        end
      end
    end

    def self.define_outputs(**outputs) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
      outputs.each_key do |output|
        define_method(output) do
          instance_variable_get("@#{output}")
        end
      end

      define_method(:define_outputs) do
        outputs.each_key do |output|
          instance_variable_set("@#{output}", Signals::Signal.new(false))
          @output_targets << output
        end
      end

      define_method(:evaluate) do
        outputs.each do |output, evaluator|
          signal = instance_variable_get("@#{output}")
          if evaluator.call(*@input_targets.map do |input|
            instance_variable_get("@#{input}").current
          end)
            signal.on
          else
            signal.off
          end
        end
      end
    end

    def self.diagram(source)
      define_method(:to_s) do
        @input_targets.concat(@output_targets).reduce(source) do |result, input|
          result.gsub(/\(#{input}\)/i, "(#{instance_variable_get("@#{input}")})#{"-" * (input.size - 1)}")
        end
      end
    end
  end
end
