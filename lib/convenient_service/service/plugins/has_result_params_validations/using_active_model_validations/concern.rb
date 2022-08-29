# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultParamsValidations
        module UsingActiveModelValidations
          module Concern
            include Support::Concern

            included do |service_class|
              service_class.include ::ActiveModel::Validations
            end
          end
        end
      end
    end
  end
end
