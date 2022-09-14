# frozen_string_literal: true

##
# NOTE: Appraisal sets `BUNDLE_GEMFILE' env variable.
# This is how appraisals can be differentiated from each other.
# https://github.com/thoughtbot/appraisal/blob/v2.4.1/lib/appraisal/command.rb#L36
#
# If `BUNDLE_GEMFILE' is an empty string, then `APPRAISAL_NAME' is resolved to an empty string as well.
# User passed `APPRAISAL_NAME' has a precedence.
#
# IMPORTANT: `APPRAISAL_NAME' env variable should be initialized as far as it is possible.
#
ENV["APPRAISAL_NAME"] ||= ENV["BUNDLE_GEMFILE"].to_s.then(&File.method(:basename)).then { |name| name.end_with?(".gemfile") ? name.delete_suffix(".gemfile") : "" }

require_relative "coverage_helper"

require "bundler/setup"
require "convenient_service"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require_relative "support/convenient_service"
require_relative "support/shoulda_matchers"
