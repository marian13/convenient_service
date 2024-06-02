# frozen_string_literal: true

require "convenient_service/dependencies/only_queries"

##
# NOTE: TruffleRuby 22.3 does NOT implement `running?`, but it is in master.
# - https://github.com/oracle/truffleruby/commit/2e838f15552ae7e16cf7eab8b74265fae80e8202
# - https://ruby-doc.org/stdlib-2.7.0/libdoc/coverage/rdoc/Coverage.html#method-c-start
# - https://github.com/simplecov-ruby/simplecov/blob/v0.22.0/lib/simplecov.rb#L345
# - https://github.com/simplecov-ruby/simplecov/blob/v0.22.0/lib/simplecov/configuration.rb#L432
#
# NOTE: Fixing `running?` causes the domino effect, that is why coverage for TruffeRuby 22.3 is disabled.
#
return if ConvenientService::Dependencies.ruby.truffleruby?

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
##

require "simplecov"
require "simplecov-lcov"

SimpleCov::Formatter::LcovFormatter.config do |config|
  ##
  # NOTE: Replaces dots since they have specific meaning in globs. Check:
  # - https://github.com/isaacs/node-glob#glob-primer
  # - convenient_service/.github/workflows/ci.yml
  #
  escape = ->(name) { name.tr(".", "_") }

  ##
  #
  #
  appraisal_name = escape[ConvenientService::Dependencies.appraisal_coverage_name]

  ##
  #
  #
  ruby_version = escape[ConvenientService::Dependencies.ruby.engine_version.major_minor]

  ##
  # NOTE: There is also `rspec`.
  #
  test_framework = "minitest"

  ##
  # https://github.com/fortissimo1997/simplecov-lcov#output-report-as-single-file
  #
  config.report_with_single_file = true

  ##
  # https://github.com/fortissimo1997/simplecov-lcov#output-report-as-single-file
  #
  config.single_report_path = File.join("coverage", test_framework, ruby_version, appraisal_name, "lcov.info")
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::LcovFormatter
])

SimpleCov.start do
  ##
  # NOTE: Enables branch coverage (requires Ruby 2.5+).
  # https://github.com/simplecov-ruby/simplecov#branch-coverage-ruby--25
  # https://github.com/simplecov-ruby/simplecov#primary-coverage
  #
  enable_coverage :branch

  add_filter "/test/"
end
