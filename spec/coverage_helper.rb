# frozen_string_literal: true

##
# Coverage using SimpleCov.
#
# NOTE: What is SimpleCov?
# https://github.com/simplecov-ruby/simplecov
#
# NOTE: What is lcov and how to set up it?
# - https://github.com/fortissimo1997/simplecov-lcov
# - https://github.com/tagliala/coveralls-ruby-reborn#github-actions
#
# NOTE: How to deploy coverage data to Coveralls using GitHub Actions?
# - https://github.com/marketplace/actions/coveralls-github-action
# - https://github.com/coverallsapp/github-action/issues/29
#
# IMPORTANT: Why `convenient_service/version.rb` is ignored? See:
# https://github.com/simplecov-ruby/simplecov/issues/557
#

##
# HACK: Fixes the following error for older Ruby versions.
#
#   Formatter SimpleCov::Formatter::LcovFormatter failed with NoMethodError: undefined method `branch_coverage?' for SimpleCov:Module
#
# https://github.com/fortissimo1997/simplecov-lcov/pull/25/files
#
# TODO: Remove when support for Rubies lower than 2.5 will be dropped.
#
if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.5")
  module SimpleCov
    class << self
      def branch_coverage?
        false
      end
    end
  end
end

require "simplecov"
require "simplecov-lcov"

SimpleCov::Formatter::LcovFormatter.config do |config|
  config.report_with_single_file = true
  config.single_report_path = "coverage/lcov.info"
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::LcovFormatter
])

SimpleCov.start do
  add_filter "/spec/"
end
