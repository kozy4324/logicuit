# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

require "rubocop/rake_task"

RuboCop::RakeTask.new

require "steep/rake_task"
Steep::RakeTask.new do |t|
  t.check.severity_level = :error
  t.watch.verbose
end

desc "Generate rbs files from inline comments"
task "rbs-inline" do
  sh "rbs-inline --output lib"
end

task default: %i[test rubocop rbs-inline steep]
