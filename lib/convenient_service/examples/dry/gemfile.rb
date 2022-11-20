# frozen_string_literal: true

require_relative "gemfile/dry_service"
require_relative "gemfile/services"

##
# @internal
#   Usage example:
#
#   result = ConvenientService::Examples::Dry::Gemfile.format("Gemfile")
#   result = ConvenientService::Examples::Dry::Gemfile.format("spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Dry
      module Gemfile
        class << self
          def format(path)
            Services::Format[path: path]
          end
        end
      end
    end
  end
end
