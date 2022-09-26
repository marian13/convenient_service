# frozen_string_literal: true

module ConvenientService
  module Examples
    module Dry
      module Gemfile
        module Services
          class AssertFileNotEmpty
            include DryService::Config

            option :path

            contract do
              schema do
                required(:path).value(:string)
              end
            end

            def result
              return error(message: "File with path `#{path}` is empty") if ::File.zero?(path)

              success
            end
          end
        end
      end
    end
  end
end
