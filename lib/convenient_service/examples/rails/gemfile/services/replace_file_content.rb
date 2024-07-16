# frozen_string_literal: true

module ConvenientService
  module Examples
    module Rails
      class Gemfile
        module Services
          class ReplaceFileContent
            include RailsService::Config

            attribute :path, :string
            attribute :content, :string

            validates :path, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?

            validate :content_not_nil if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?

            step Services::AssertFileExists, in: :path
            step :result, in: :path

            def result
              ::File.write(path, content)

              success
            end

            private

            def content_not_nil
              errors.add(:content, "can't be nil") if content.nil?
            end
          end
        end
      end
    end
  end
end
