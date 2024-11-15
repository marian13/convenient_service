# frozen_string_literal: true

##
# Configures coverage tracking.
#
require_relative "coverage_helper"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  ##
  # NOTE: Does NOT work.
  # - https://rspec.info/features/3-12/rspec-core/command-line/pattern-option
  #
  # config.pattern = "spec/**/*_spec.rb"
end

require_relative "support/thread_backtraces"
require_relative "support/convenient_service"
require_relative "support/faker"

##
# NOTE: Waits for `should-matchers` full support.
#
# require_relative "support/shoulda_matchers"
