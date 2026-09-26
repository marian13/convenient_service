# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultParamsValidations
        module UsingActiveModelValidations
          module Concern
            include ::ConvenientService::Concern

            class << self
              ##
              # @param skip_validations [Boolean]
              # @return [Module]
              #
              def with(skip_validations: false)
                return self unless skip_validations

                Plugins::HasJSendResultParamsValidations::UsingActiveModelValidations::NoOpConcern
              end
            end

            included do
              include ::ActiveModel::Validations
            end
          end
        end
      end
    end
  end
end
