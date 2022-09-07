# frozen_string_literal: true

##
# Usage example:
#
# result = ConvenientService::Examples::Gemfile::Entries::Format.result(path: "Gemfile")
# result = ConvenientService::Examples::Gemfile::Entries::Format.result(path: "spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Gemfile
      module Entries
        class Format
          include ConvenientService::Configs::Standard

          include ConvenientService::Configs::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment
          include ConvenientService::Configs::HasAttributes::UsingActiveModelAttributes
          include ConvenientService::Configs::HasResultParamsValidations::UsingActiveModelValidations

          attribute :path, :string

          def result
            Services::Format.result(path: path)
          end
        end
      end
    end
  end
end
