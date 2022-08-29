# frozen_string_literal: true

module ConvenientService
  module Examples
    module Gemfile
      module Services
        class AssertFileNotEmpty
          include ConvenientService::Configs::Rails

          attr_accessor :path

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
