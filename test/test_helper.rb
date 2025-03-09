# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "logicuit"

require "minitest/autorun"

module Minitest
  class Test
    def assert_as_truth_table(subject_class)
      subject_class.new.truth_table.each do |row|
        args = row.values_at(*subject_class.new.input_targets).map { _1 ? 1 : 0 }
        subject = subject_class.new(*args)

        row.each do |key, value|
          assert_equal value, subject.send(key).current,
                       "#{subject_class}.new(#{args.join(", ")}).#{key} should be #{value}"
        end
      end
    end

    def assert_behavior_against_truth_table(subject_class) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
      truth_table = subject_class.new.truth_table
      input_targets = subject_class.new.input_targets
      output_targets = subject_class.new.output_targets

      truth_table.each do |row|
        args = row.values_at(*input_targets).map { _1 ? 1 : 0 }
        input_targets.each do |input_target|
          subject = subject_class.new(*args)
          target_action = row[input_target] ? :off : :on
          state_before_action = input_targets.map { |attr| [attr, subject.send(attr).current] }.to_h

          subject.send(input_target).send(target_action)
          state_after_action = input_targets.map { |attr| [attr, subject.send(attr).current] }.to_h
          target_state = truth_table.find { |r| r.slice(*input_targets) == state_after_action }

          target_state.slice(*output_targets).each do |key, value|
            assert_equal value, subject.send(key).current,
                         "Input state is #{state_before_action}, #{subject_class}.#{input_target}.#{target_action} should set ##{key} to #{value}" # rubocop:disable Layout/LineLength
          end
        end
      end
    end
  end
end
