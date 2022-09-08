# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module Gemfile
        module Services
          class AssertFileExists
            include ConvenientService::Configs::Standard

            attr_accessor :path

            def initialize(path:)
              @path = path
            end

            def result
              return failure(path: "Path is `nil'") if path.nil?
              return failure(path: "Path is empty") if path.empty?

              return error("File with path `#{path}' does NOT exist") unless ::File.exist?(path)

              success
            end
          end
        end
      end
    end
  end
end
