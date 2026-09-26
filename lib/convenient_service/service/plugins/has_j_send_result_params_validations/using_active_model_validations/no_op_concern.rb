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
              # @see https://github.com/rails/rails/blob/v8.1.4/activemodel/lib/active_model/validations/validates.rb#L111
              #
              def validates(*attributes)
              end

              ##
              # @return [void]
              # @see https://github.com/rails/rails/blob/v8.1.4/activemodel/lib/active_model/validations/validates.rb#L153
              #
              def validates!(*attributes)
              end

              ##
              # @return [void]
              # @see https://github.com/rails/rails/blob/v8.1.4/activemodel/lib/active_model/validations.rb#L89
              #
              def validates_each(*attr_names, &block)
              end

              ##
              # @return [void]
              # @see https://github.com/rails/rails/blob/v8.1.4/activemodel/lib/active_model/validations.rb#L162
              #
              def validate(*args, &block)
              end

              ##
              # @return [void]
              # @see https://github.com/rails/rails/blob/v8.1.4/activemodel/lib/active_model/validations.rb#L206
              #
              def validators
              end

              ##
              # @return [void]
              # @see https://github.com/rails/rails/blob/v8.1.4/activemodel/lib/active_model/validations.rb#L268
              #
              def validators_on(*attributes)
              end
            end

            instance_methods do
              ##
              # @return [Array]
              # @see https://github.com/rails/rails/blob/v8.1.4/activemodel/lib/active_model/validations.rb#L330
              #
              def errors
                @errors ||= []
              end

              ##
              # @return [Boolean]
              # @see https://github.com/rails/rails/blob/v8.1.4/activemodel/lib/active_model/validations.rb#L363
              #
              def valid?(context = nil)
                true
              end

              ##
              # @return [Boolean]
              # @see https://github.com/rails/rails/blob/v8.1.4/activemodel/lib/active_model/validations.rb#L372
              #
              alias_method :validate, :valid?

              ##
              # @return [Boolean]
              # @see https://github.com/rails/rails/blob/v8.1.4/activemodel/lib/active_model/validations.rb#L410
              #
              def invalid?(context = nil)
                false
              end

              ##
              # @return [Boolean]
              # @see https://github.com/rails/rails/blob/v8.1.4/activemodel/lib/active_model/validations.rb#L419
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
