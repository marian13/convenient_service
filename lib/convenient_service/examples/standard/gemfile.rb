# frozen_string_literal: true

require_relative "gemfile/services"

##
# @internal
#   Usage example:
#
#   result = ConvenientService::Examples::Standard::Gemfile.format("Gemfile")
#   result = ConvenientService::Examples::Standard::Gemfile.format("spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Standard
      class Gemfile
        include ConvenientService::Feature

        entry :format do |path|
          Services::Format[path: path]
        end
      end
    end
  end
end
