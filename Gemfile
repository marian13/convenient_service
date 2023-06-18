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
