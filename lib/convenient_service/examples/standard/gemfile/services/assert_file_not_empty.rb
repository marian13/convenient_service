# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module Gemfile
        module Services
          class AssertFileNotEmpty
            include ConvenientService::Configs::Standard

            include ConvenientService::Configs::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment
            include ConvenientService::Configs::HasAttributes::UsingActiveModelAttributes
            include ConvenientService::Configs::HasResultParamsValidations::UsingActiveModelValidations

            attr_accessor :path

            validates :path, presence: true

            def result
              return error(message: "File with path `#{path}' is empty") if ::File.zero?(path)

              success
            end
          end
        end
      end
    end
  end
end
