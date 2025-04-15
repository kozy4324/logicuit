# frozen_string_literal: true

# Logicuit module
module Logicuit
  # base class for all gates and circuits
  class Base
    def initialize(*args)
      @input_targets = []
      @output_targets = []
      @clock = false
      @components = []
      define_inputs(*args)
      define_outputs
      assembling
      @initialized = true
      evaluate
    end

    def define_inputs(*args); end
    def define_outputs; end
    def assembling; end
    def evaluate(*args); end

    attr_reader :input_targets, :output_targets, :clock, :components, :initialized

    def self.define_inputs(*args, **kwargs)
      # define getter methods for inputs
      attr_reader(*args)

      # define initializer for inputs
      define_method(:define_inputs) do |*instance_method_args|
        @clock = true if kwargs&.key?(:clock)
        args.each_with_index do |input, index|
          signal = Signals::Signal.new(instance_method_args[index] == 1)
          signal >> self unless clock
          instance_variable_set("@#{input}", signal)
          @input_targets << input
        end
        Signals::Clock >> self if clock
      end
    end

    def self.define_outputs(*args, **kwargs)
      # define getter methods for outputs
      attr_reader(*(args + kwargs.keys))

      # define initializer for outputs
      define_method(:define_outputs) do
        (args + kwargs.keys).each do |output|
          instance_variable_set("@#{output}", Signals::Signal.new(false))
          @output_targets << output
        end
      end

      # define evaluate method
      return if kwargs.empty?

      define_method(:evaluate) do |*override_args|
        return unless initialized

        kwargs.each do |output, evaluator|
          signal = instance_variable_get("@#{output}")
          e_args = if override_args.empty?
                     @input_targets.map do |input|
                       instance_variable_get("@#{input}").current
                     end
                   else
                     override_args
                   end
          if evaluator.call(*e_args)
            signal.on
          else
            signal.off
          end
        end
      end
    end

    def self.assembling
      define_method(:assembling) do
        (yield(*(@input_targets + @output_targets).map do |target|
          instance_variable_get("@#{target}")
        end) || []).each do |component|
          @components << component
        end
      end
    end

    def self.diagram(source)
      define_method(:to_s) do
        source_ = @input_targets.reduce(source) do |result, input|
          result.gsub(/\(#{input}\)/i, "(#{instance_variable_get("@#{input}")})#{"-" * (input.size - 1)}")
        end
        @output_targets.reduce(source_) do |result, output|
          result.gsub(/\(#{output}\)/i, "#{"-" * (output.size - 1)}(#{instance_variable_get("@#{output}")})")
        end
      end
    end

    def self.truth_table(source)
      define_method(:truth_table) do
        rows = source.strip.split("\n").map { |row| row.gsub(/#.*$/, "") }
        headers = rows.shift.split("|").map(&:strip).reject(&:empty?).map(&:downcase).map(&:to_sym)
        rows.shift # devide line
        table = rows.map do |row|
          row.split("|").map(&:strip).reject(&:empty?).map(&:downcase).map do |v|
            case v
            when "^"
              :clock
            when "x"
              :any
            when "1"
              true
            when "0"
              false
            else
              raise "Invalid value in truth table: #{v}" unless headers.include?(v.to_sym)

              [:ref, v.to_sym]
            end
          end
        end.select do |values|
          headers.size == values.size
        end.map do |values|
          array = [values]
          while array.any? { it.any? { |v| v == :any } }
            target_index = array.find_index { it.any? { |v| v == :any } }
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
        end.flatten!(1).map do |values|
          headers.zip(values).to_h
        end
        table
      end
    end

    def self.run(opts = {})
      ::Logicuit.run(new, **opts)
    end
  end
end
