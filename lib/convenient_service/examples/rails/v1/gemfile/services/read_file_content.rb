# frozen_string_literal: true

module ConvenientService
  module Examples
    module Rails
      module V1
        class Gemfile
          module Services
            class ReadFileContent
              include RailsService::Config

              attribute :path, :string

              validates :path, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations?

              step Services::AssertFileExists, in: :path
              step Services::AssertFileNotEmpty, in: :path
              step :result, in: :path, out: :content

              def result
                success(data: {content: ::File.read(path)})
              end
            end
          end
        end
      end
    end
  end
end
