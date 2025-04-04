# frozen_string_literal: true

# Logicuit module
module Logicuit
  # base class for all gates and circuits
  class Base
    def self.tag(*tags)
      tags.each do |tag|
        registry[tag] = self
      end
    end

    @@registry = {} # rubocop:disable Style/ClassVars

    def self.registry
      @@registry
    end

    def initialize(*args)
      @input_targets = []
      @output_targets = []
      @clock = false
      @components = []
      define_inputs(*args) if respond_to?(:define_inputs)
      define_outputs if respond_to?(:define_outputs)
      assembling if respond_to?(:assembling)
      evaluate if respond_to?(:evaluate)
    end

    def evaluate(*args); end

    attr_reader :input_targets, :output_targets, :clock, :components

    def self.define_inputs(*args, **kwargs)
      # define getter methods for inputs
      args.each do |input|
        define_method(input) do
          instance_variable_get("@#{input}")
        end
      end

      # define initializer for inputs
      define_method(:define_inputs) do |*instance_method_args|
        instance_variable_set("@clock", true) if kwargs&.key?(:clock)
        args.each_with_index do |input, index|
          signal = Signals::Signal.new(instance_method_args[index] == 1)
          signal.on_change << self unless clock
          instance_variable_set("@#{input}", signal)
          @input_targets << input
        end
        Signals::Clock.on_tick << self if clock
      end

      # define bulk_setter for inputs
      define_method(:bulk_set) do |str|
        args.zip(str.gsub(/\s/, "").split("")).each do |input, value|
          signal = send(input)
          if value == "1"
            signal.on
          else
            signal.off
          end
        end
      end
    end

    def self.define_outputs(*args, **kwargs)
      # define getter methods for outputs
      (args + kwargs.keys).each do |output|
        define_method(output) do
          instance_variable_get("@#{output}")
        end
      end

      # define initializer for outputs
      define_method(:define_outputs) do
        (args + kwargs.keys).each do |output|
          instance_variable_set("@#{output}", Signals::Signal.new(false))
          @output_targets << output
        end
      end

      # define evaluate method
      define_method(:evaluate) do |*override_args|
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

    def self.define_instructions(**kwargs)
      define_method(:instructions) do
        kwargs.keys
      end

      define_method(:execute) do |input|
        # input: e.g. "ADD A,Im"
        kwargs.find do |instruction, block|
          match = Regexp.new(instruction.gsub(/Im/, "([01]{4})")).match(input)
          next unless match

          if match[1]
            instance_exec(*match[1].split(""), &block)
          else
            instance_exec(&block)
          end
          true
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
        rows = source.strip.split("\n")
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
        end.select do |values| # rubocop:disable Style/MultilineBlockChain
          headers.size == values.size
        end.map do |values| # rubocop:disable Style/MultilineBlockChain
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
        end.flatten!(1).map do |values| # rubocop:disable Style/MultilineBlockChain
          headers.zip(values).to_h
        end
        table
      end
    end
  end

  def self.run(sym, hz: 1, noclear: false) # rubocop:disable Naming/MethodParameterName
    circuit = Base.registry[sym.upcase.to_sym].new

    render = lambda {
      system("clear") unless noclear
      puts circuit
      puts
      puts "tick: #{Signals::Clock.tick_count}" if circuit.clock
      if circuit.respond_to?(:instructions)
        puts "instructions: #{circuit.instructions.join "|"}"
      elsif circuit.input_targets.any?
        puts "input: #{circuit.input_targets.join ","}?"
      end
    }

    if circuit.clock && hz.nonzero?
      Thread.new do
        loop do
          render.call
          sleep 1.0 / hz
          Signals::Clock.tick
        end
      end
    else
      render.call
    end

    while (input = gets.chomp)
      if circuit.respond_to?(:execute) && circuit.execute(input)
        Signals::Clock.tick
        render.call # rubocop:disable Style/IdenticalConditionalBranches
      else
        key = input.to_sym
        unless circuit.respond_to? key
          if circuit.clock && hz.zero?
            Signals::Clock.tick
            render.call
          end
          next
        end

        signal = circuit.send(key)
        if signal.current
          signal.off
        else
          signal.on
        end
        render.call # rubocop:disable Style/IdenticalConditionalBranches
      end
    end
  end
end
