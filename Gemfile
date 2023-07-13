# frozen_string_literal: true

source "https://rubygems.org"

##
# Specify your gem's dependencies in `convenient_service.gemspec`.
# - https://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/
#
gemspec

group :development, :test do
  ##
  # NOTE: Temporarily pointing appraisal at the commit in the main branch until the following issue is resolved:
  # - https://github.com/thoughtbot/appraisal/issues/199
  #
  gem "appraisal", github: "thoughtbot/appraisal", ref: "b200e636903700098bef25f4f51dbc4c46e4c04c"
end

group :development do
  ##
  # TODO: Move to `gemspec` if `rubocop-magic_numbers` maintainers agree to support Ruby 2.7. Delete otherwise.
  #   ##
  #   # Used for linting magic numbers in Ruby files.
  #   # https://github.com/meetcleo/rubocop-magic_numbers
  #   #
  #   spec.add_development_dependency "rubocop-magic_numbers", "~> 0.4.0"
  #
  gem "rubocop-magic_numbers", github: "marian13/rubocop-magic_numbers", ref: "752ed423bc1969fe4dbd7ab62274ec9ea9202f01"
end

##
# TODO: Uncomment if a license key is approved.
# - https://github.com/mbj/mutant/tree/a19e11a07e71a40cfa62636f7aea611e314de841#getting-an-opensource-license
#
# source 'https://${plan}:${key}@gem.mutant.dev' do
#   gem 'mutant-license'
# end
