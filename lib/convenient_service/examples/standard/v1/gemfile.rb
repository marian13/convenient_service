# frozen_string_literal: true

require_relative "gemfile/services"

##
# @internal
#   Usage example:
#
#   result = ConvenientService::Examples::Standard::V1::Gemfile.format("Gemfile")
#   result = ConvenientService::Examples::Standard::V1::Gemfile.format("spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Standard
      module V1
        class Gemfile
          include ConvenientService::Feature

          entry :format do |path|
            Services::Format[path: path]
          end
        end
      end
    end
  end
end
