# frozen_string_literal: true

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/rubygems/rdoc/Gem/Version.html
#   - https://github.com/rubygems/rubygems
#   - https://github.com/rubygems/rubygems/blob/master/lib/rubygems/version.rb
#
require "rubygems"

##
# This file load extracted dependencies.
#
# @internal
#   https://github.com/marian13/convenient_service/wiki/Docs:-Dependencies
#
require_relative "queries"

##
# `ConvenientService::Dependencies` can dynamically require plugins/extensions that have external dependencies.
#
# @internal
#   https://github.com/marian13/convenient_service/wiki/Docs:-Dependencies
#
module ConvenientService
  module Dependencies
    extend Queries
  end
end
