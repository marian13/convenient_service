# frozen_string_literal: true

module ConvenientService
  module Examples
    module Rails
      module Gemfile
        module Services
          class AssertFileExists
            include RailsService::Config

            attribute :path, :string

            validates :path, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations?

            def result
              return error("File with path `#{path}` does NOT exist") unless ::File.exist?(path)

              success
            end
          end
        end
      end
    end
  end
end
