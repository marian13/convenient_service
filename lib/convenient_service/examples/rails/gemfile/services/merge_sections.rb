# frozen_string_literal: true

module ConvenientService
  module Examples
    module Rails
      module Gemfile
        module Services
          class MergeSections
            include RailsService::Config

            attribute :header, :string
            attribute :body, :string

            validates :header, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations?
            validates :body, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations?

            def result
              success(merged_sections: "#{header}\n#{body}")
            end
          end
        end
      end
    end
  end
end
