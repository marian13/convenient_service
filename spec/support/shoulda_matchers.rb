# frozen_string_literal: true

require "shoulda-matchers"

##
# Configures `shoulda-matchers`.
# https://github.com/thoughtbot/shoulda-matchers#rspec
#
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :active_record
    with.library :active_model
  end
end
