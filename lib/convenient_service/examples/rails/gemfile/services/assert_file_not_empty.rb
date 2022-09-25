# frozen_string_literal: true

module ConvenientService
  module Examples
    module Rails
      module Gemfile
        module Services
          class AssertFileNotEmpty
            include RailsService::Config

            attribute :path, :string

            validates :path, presence: true

            def result
              return error(message: "File with path `#{path}' is empty") if ::File.zero?(path)

              success
            end
          end
        end
      end
    end
  end
end
