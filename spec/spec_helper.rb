# frozen_string_literal: true

##
# Makes sure that internal `ENV` variables are available.
#
require_relative "../env"

##
# Configures coverage tracking.
#
require_relative "coverage_helper"

##
# Allows to require gems listed in `Gemfile` and `gemspec`.
#
require "bundler/setup"

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
require_relative "support/faker"

##
# NOTE: Waits for `should-matchers` full support.
#
# require_relative "support/shoulda_matchers"
