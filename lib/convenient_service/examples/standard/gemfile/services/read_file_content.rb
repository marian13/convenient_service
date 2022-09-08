# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module Gemfile
        module Services
          class ReadFileContent
            include ConvenientService::Configs::Standard

            include ConvenientService::Configs::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment
            include ConvenientService::Configs::HasAttributes::UsingActiveModelAttributes
            include ConvenientService::Configs::HasResultParamsValidations::UsingActiveModelValidations

            attr_accessor :path

            validates :path, presence: true

            step Services::AssertFileExists, in: :path
            step Services::AssertFileNotEmpty, in: :path
            step :result, in: :path, out: :content

            def result
              success(data: {content: ::File.read(path)})
            end
          end
        end
      end
    end
  end
end
