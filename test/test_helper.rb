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
  end
end
