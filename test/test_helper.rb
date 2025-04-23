# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "logicuit"

require "minitest/autorun"

module Minitest
  class Test
    def assert_matches_truth_table(subject_class)
      subject_class.verify_against_truth_table
      # If the behavior does not match the truth table, a RuntimeError will be thrown,
      # and this assert will not be executed.
      assert true
    end
  end
end
