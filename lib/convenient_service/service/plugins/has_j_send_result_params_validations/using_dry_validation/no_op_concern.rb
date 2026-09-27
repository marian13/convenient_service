# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultParamsValidations
        module UsingDryValidation
          module NoOpConcern
            include ::ConvenientService::Concern

            class << self
              ##
              # @param skip_validations [Boolean]
              # @return [Module]
              #
              def with(skip_validations: false)
                return self if skip_validations

                Plugins::HasJSendResultParamsValidations::UsingDryValidation::Concern
              end
            end

            class_methods do
              ##
              # @param block [Proc, nil]
              # @return [nil]
              #
              # @note `Class<Dry::Validation::Contract>` is returned when `skip_validations` option detail is `false` or not used.
              #
              def contract(&block)
              end
            end
          end
        end
      end
    end
  end
end
