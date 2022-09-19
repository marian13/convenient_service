# frozen_string_literal: true

module ConvenientService
  module Examples
    module Dry
      module Gemfile
        module Services
          class AssertFileExists
            include DryServiceConfig

            option :path

            contract do
              schema do
                required(:path).value(:string)
              end
            end

            def result
              return error("File with path `#{path}' does NOT exist") unless ::File.exist?(path)

              success
            end
          end
        end
      end
    end
  end
end
