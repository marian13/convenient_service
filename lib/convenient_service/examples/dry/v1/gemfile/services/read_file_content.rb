# frozen_string_literal: true

module ConvenientService
  module Examples
    module Dry
      module V1
        class Gemfile
          module Services
            class ReadFileContent
              include DryService::Config

              option :path

              contract do
                schema do
                  required(:path).filled(:string)
                end
              end

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
end
