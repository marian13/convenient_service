# frozen_string_literal: true

module ConvenientService
  module Examples
    module Dry
      class Gemfile
        module Services
          class AssertFileExists
            include DryService::Config

            option :path

            contract do
              schema do
                required(:path).filled(:string)
              end
            end

            def result
              return error("File with path `#{path}` does NOT exist") unless ::File.exist?(path)

              success
            end
          end
        end
      end
    end
  end
end
