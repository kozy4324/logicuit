# frozen_string_literal: true

# steep:ignore:start

# Logicuit module
module Logicuit
  # base class for all gates and circuits
  class DSL
    def initialize(*args)
      @input_targets = []
      @inputs_as_bool_struct = nil
      @output_targets = []
      @clock = false
      @components = []
      inputs(*args)
      outputs
      assembling
      @initialized = true
      evaluate
    end

    def inputs(*args); end
    def outputs; end
    def assembling; end
    def evaluate(*args); end

    attr_reader :input_targets, :output_targets, :clock, :components, :initialized

    def self.inputs(*args, **kwargs)
      # define getter methods for inputs
      attr_reader(*args)

      # define initializer for inputs
      define_method(:inputs) do |*instance_method_args|
        @clock = true if kwargs&.key?(:clock)
        args.each_with_index do |input, index|
          signal = Signals::Signal.new(instance_method_args[index] == 1)
          signal >> self unless clock
          instance_variable_set("@#{input}", signal)
          @input_targets << input
        end
        Signals::Clock >> self if clock
        @inputs_as_bool_struct = Struct.new(*@input_targets)
      end
    end

    def [](*keys)
      if keys.size == 1
        send(keys.first)
      elsif keys.size > 1
        Signals::SignalGroup.new(*(keys.map { |key| send(key) }))
      else
        raise ArgumentError, "Invalid number of arguments"
      end
    end

    def self.outputs(*args, **kwargs)
      # define getter methods for outputs
      attr_reader(*(args + kwargs.keys))

      # define initializer for outputs
      define_method(:outputs) do
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
          ret = if evaluator.arity > 0
                  evaluator.call(self)
                else
                  @inputs_as_bool_struct.new(*e_args).instance_exec(&evaluator)
                end
          if ret
            signal.on
          else
            signal.off
          end
        end
      end
    end

    def self.assembling(&block)
      define_method(:assembling) do
        ret = instance_eval(&block)
        ret.each { @components << _1 } if ret.is_a?(Array)
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
          while array.any? { _1.any? { |v| v == :any } }
            target_index = array.find_index { _1.any? { |v| v == :any } }
            next if target_index.nil? # avoid rbs error...

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

    def self.verify_against_truth_table
      new.truth_table.each do |row|
        args = row.values_at(*new.input_targets).map { _1 ? 1 : 0 }
        subject = new(*args)

        previous_values = row.reject do |_k, v|
          v == :clock
        end.keys.reduce({}) { |acc, key| acc.merge(key => subject.send(key).current) }

        Signals::Clock.tick if row.values.find :clock

        row.each do |key, value|
          next if value == :clock

          if value.is_a?(Array) && value.first == :ref
            expected = previous_values[value.last]

            raise "#{self}.new(#{args.join(", ")}).#{key} should be #{expected ? 1 : 0}" unless expected == subject.send(key).current
          else
            raise "#{self}.new(#{args.join(", ")}).#{key} should be #{value ? 1 : 0}" unless value == subject.send(key).current
          end
        end
      end
    end

    def self.run(opts = {})
      ::Logicuit.run(new, **opts)
    end
  end
end

# steep:ignore:end
