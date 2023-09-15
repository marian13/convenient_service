# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      class Gemfile
        module Services
          class AssertFileNotEmpty
            include ConvenientService::Standard::Config

            attr_reader :path

            def initialize(path:)
              @path = path
            end

            def result
              return error("Path is `nil`") if path.nil?
              return error("Path is empty") if path.empty?

              return failure("File with path `#{path}` is empty") if ::File.zero?(path)

              success
            end
          end
        end
      end
    end
  end
end
