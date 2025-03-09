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

    attr_reader :input_targets, :output_targets

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
        (@input_targets + @output_targets).reduce(source) do |result, input|
          result.gsub(/\(#{input}\)/i, "(#{instance_variable_get("@#{input}")})#{"-" * (input.size - 1)}")
        end
      end
    end

    def self.truth_table(source) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
      define_method(:truth_table) do # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity,Metrics/BlockLength
        rows = source.strip.split("\n")
        headers = rows.shift.split("|").map(&:strip).reject(&:empty?).map(&:downcase).map(&:to_sym)
        rows.shift # devide line
        table = rows.map do |row|
          row.split("|").map(&:strip).reject(&:empty?).map(&:downcase).map do |v|
            case v
            when "x"
              :any
            when "1"
              true
            when "0"
              false
            else
              raise "Invalid value in truth table: #{v}"
            end
          end
        end.select do |values| # rubocop:disable Style/MultilineBlockChain
          headers.size == values.size
        end.map do |values| # rubocop:disable Style/MultilineBlockChain
          array = [values]
          while array.any? { |values| values.any? { |v| v == :any } }
            target_index = array.find_index { |values| values.any? { |v| v == :any } }
            target = array[target_index]
            prop_index = target.find_index { |v| v == :any }
            array.delete_at(target_index)
            array.insert(target_index, *[true, false].map do |v|
              target.dup.tap do |a|
                a[prop_index] = v
              end
            end)
          end
          array
        end.flatten!(1).map do |values| # rubocop:disable Style/MultilineBlockChain
          headers.zip(values).to_h
        end
        table
      end
    end
  end
end
