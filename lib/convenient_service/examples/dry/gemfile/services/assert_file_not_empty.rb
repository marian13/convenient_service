# frozen_string_literal: true

module ConvenientService
  module Examples
    module Dry
      class Gemfile
        module Services
          class AssertFileNotEmpty
            include DryService::Config

            option :path

            contract do
              schema do
                required(:path).filled(:string)
              end
            end

            def result
              return failure("File with path `#{path}` is empty") if ::File.zero?(path)

              success
            end
          end
        end
      end
    end
  end
end
