# frozen_string_literal: true

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
