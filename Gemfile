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

##
# TODO: Uncomment if a license key is approved.
# - https://github.com/mbj/mutant/tree/a19e11a07e71a40cfa62636f7aea611e314de841#getting-an-opensource-license
#
# source 'https://${plan}:${key}@gem.mutant.dev' do
#   gem 'mutant-license'
# end
