# frozen_string_literal: true

module ConvenientService
  module Examples
    module Gemfile
      module Services
        class AssertFileExists
          include ConvenientService::Configs::Rails

          ##
          # NOTE: accessor is needed for ActiveModel::AttributeAssignment
          # https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html
          #
          attr_accessor :path

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
