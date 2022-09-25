# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module Gemfile
        module Services
          class AssertFileNotEmpty
            include ConvenientService::Standard::Config

            attr_accessor :path

            def initialize(path:)
              @path = path
            end

            def result
              return failure(data: {path: "Path is `nil'"}) if path.nil?
              return failure(data: {path: "Path is empty"}) if path.empty?

              return error(message: "File with path `#{path}' is empty") if ::File.zero?(path)

              success
            end
          end
        end
      end
    end
  end
end
