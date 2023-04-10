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

##
# TODO: More docs for `autorun`.
# - https://github.com/minitest/minitest
# - https://minitest.rubystyle.guide
# - https://semaphoreci.com/community/tutorials/getting-started-with-minitest
# - https://www.cloudbees.com/blog/getting-started-with-minitest
#
require "minitest/autorun"

##
# - https://github.com/thoughtbot/shoulda-context
#
require "shoulda-context"
