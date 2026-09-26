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
          module NoOpConcern
            include ::ConvenientService::Concern

            class << self
              ##
              # @param skip_validations [Boolean]
              # @return [Module]
              #
              def with(skip_validations: false)
                return self if skip_validations

                Plugins::HasJSendResultParamsValidations::UsingActiveModelValidations::Concern
              end
            end

            class_methods do
              ##
              # @return [void]
              #
              def validates_each(*attr_names, &block)
              end

              ##
              # @return [void]
              #
              def validate(*args, &block)
              end

              ##
              # @return [void]
              #
              def validators
              end

              ##
              # @return [void]
              #
              def validators_on(*attributes)
              end
            end

            instance_methods do
              ##
              # @return [Array]
              #
              def errors
                @errors ||= []
              end

              ##
              # @return [Boolean]
              #
              def valid?(context = nil)
                true
              end

              ##
              # @return [Boolean]
              #
              alias_method :validate, :valid?

              ##
              # @return [Boolean]
              #
              def invalid?(context = nil)
                false
              end

              ##
              # @return [Boolean]
              #
              def validate!(context = nil)
                true
              end
            end
          end
        end
      end
    end
  end
end
