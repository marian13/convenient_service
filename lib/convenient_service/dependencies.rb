# frozen_string_literal: true

require_relative "dependencies/built_in"
require_relative "dependencies/extractions"
require_relative "dependencies/queries"

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
