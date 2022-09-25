# frozen_string_literal: true

module ConvenientService
  module Examples
    module Rails
      module Gemfile
        module Services
          class AssertFileExists
            include RailsService::Config

            attribute :path, :string

            validates :path, presence: true

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
