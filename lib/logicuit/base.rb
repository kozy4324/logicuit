# frozen_string_literal: true

# Logicuit module
module Logicuit
  # base class for all gates and circuits
  class Base # rubocop:disable Metrics/ClassLength
    def initialize(*args)
      @input_targets = []
      @output_targets = []
      @clock = false
      use_clock if respond_to?(:use_clock)
      define_inputs(*args) if respond_to?(:define_inputs)
      define_outputs if respond_to?(:define_outputs)
      assembling if respond_to?(:assembling)
      evaluate if respond_to?(:evaluate)
      Signals::Clock.tick if @clock
    end

    attr_reader :input_targets, :output_targets

    def self.define_inputs(*args, **kwargs) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
      args.each do |input|
        define_method(input) do
          instance_variable_get("@#{input}")
        end
      end

      if kwargs&.key?(:clock)
        define_method(:use_clock) do
          instance_variable_set("@clock", true)
        end
      end

      define_method(:define_inputs) do |*instance_method_args|
        clock = instance_variable_get("@clock")
        args.each_with_index do |input, index|
          signal = Signals::Signal.new(instance_method_args[index] == 1)
          signal.on_change << self unless clock
          instance_variable_set("@#{input}", signal)
          @input_targets << input
        end
        Signals::Clock.on_tick << self if clock
      end
    end

    def self.define_outputs(*args, **kwargs) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
      (args + kwargs.keys).each do |output|
        define_method(output) do
          instance_variable_get("@#{output}")
        end
      end

      define_method(:define_outputs) do
        (args + kwargs.keys).each do |output|
          instance_variable_set("@#{output}", Signals::Signal.new(false))
          @output_targets << output
        end
      end

      define_method(:evaluate) do
        kwargs.each do |output, evaluator|
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

    def self.assembling
      define_method(:assembling) do
        yield(*(@input_targets + @output_targets).map { |target| instance_variable_get("@#{target}") })
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

  def self.run(sym) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    circuit = case sym
              when :dff
                Circuits::Sequential::DFlipFlop.new
              end

    Thread.new do
      while input = gets
        key = input.chomp.to_sym
        next unless circuit.respond_to? key

        signal = circuit.send(key)
        if signal.current
          signal.off
        else
          signal.on
        end
        system("clear")
        puts circuit
      end
    end

    loop do
      system("clear")
      puts circuit
      sleep 1
      Signals::Clock.tick
    end
  end
end
