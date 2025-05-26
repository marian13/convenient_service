# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: Run the following commands any time you modify gemfile or gemspec.
#   task deps:clean
#   task docker:build:all
##

source "https://rubygems.org"

##
# NOTE: Should be placed before `gemspec`.
# - https://github.com/mbj/mutant/issues/1396
# - https://github.com/mbj/mutant/tree/a19e11a07e71a40cfa62636f7aea611e314de841#getting-an-opensource-license
# - https://github.com/mbj/auom/blob/master/Gemfile#L5
#
if ENV["CONVENIENT_SERVICE_MUTANT_LICENCE_KEY"]
  source "https://oss:#{ENV["CONVENIENT_SERVICE_MUTANT_LICENCE_KEY"]}@gem.mutant.dev" do
    gem "mutant-license"
  end
end

##
# Specify your gem's dependencies in `convenient_service.gemspec`.
# - https://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/
#
gemspec
