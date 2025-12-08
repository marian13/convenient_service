# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module ForbidsConvenientServiceEntitiesAsConstructorArguments
        class Middleware < MethodChainMiddleware
          intended_for :initialize, entity: :service

          ##
          # @return [ConvenientService::Service]
          #
          alias_method :service, :entity

          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ServicePassedAsConstructorArgument, ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ResultPassedAsConstructorArgument, ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::StepPassedAsConstructorArgument]
          # @return [void]
          #
          def next(*args, **kwargs, &block)
            args.each_with_index { |value, index| validate!(index, value) }

            kwargs.each_pair { |key, value| validate!(key, value) }

            chain.next(*args, **kwargs, &block)
          end

          private

          ##
          # @param key [Integer, Symbol]
          # @param value [Object] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ServicePassedAsConstructorArgument, ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ResultPassedAsConstructorArgument, ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::StepPassedAsConstructorArgument]
          # @return [void]
          #
          def validate!(key, value)
            return unless ::ConvenientService::Core.entity?(value)

            refute_service!(key, value)
            refute_result!(key, value)
            refute_data!(key, value)
            refute_message!(key, value)
            refute_code!(key, value)
            refute_status!(key, value)
            refute_step!(key, value)

            ::ConvenientService.raise Exceptions::EntityPassedAsConstructorArgument.new(selector: selector_from(key), service: service, entity: value)
          end

          ##
          # @param key [Integer, Symbol]
          # @param value [Object] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ServicePassedAsConstructorArgument]
          # @return [void]
          #
          def refute_service!(key, value)
            return unless ::ConvenientService::Standard::Config.service?(value)

            ::ConvenientService.raise Exceptions::ServicePassedAsConstructorArgument.new(selector: selector_from(key), service: service, other_service: value)
          end

          ##
          # @param key [Integer, Symbol]
          # @param value [Object] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ResultPassedAsConstructorArgument]
          # @return [void]
          #
          def refute_result!(key, value)
            return unless ::ConvenientService::Plugins::Service::HasJSendResult.result?(value)

            ::ConvenientService.raise Exceptions::ResultPassedAsConstructorArgument.new(selector: selector_from(key), service: service, result: value)
          end

          ##
          # @param key [Integer, Symbol]
          # @param value [Object] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::DataPassedAsConstructorArgument]
          # @return [void]
          #
          def refute_data!(key, value)
            return unless ::ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data.data?(value)

            ::ConvenientService.raise Exceptions::DataPassedAsConstructorArgument.new(selector: selector_from(key), service: service, data: value)
          end

          ##
          # @param key [Integer, Symbol]
          # @param value [Object] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::MessagePassedAsConstructorArgument]
          # @return [void]
          #
          def refute_message!(key, value)
            return unless ::ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.message?(value)

            ::ConvenientService.raise Exceptions::MessagePassedAsConstructorArgument.new(selector: selector_from(key), service: service, message: value)
          end

          ##
          # @param key [Integer, Symbol]
          # @param value [Object] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::CodePassedAsConstructorArgument]
          # @return [void]
          #
          def refute_code!(key, value)
            return unless ::ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.code?(value)

            ::ConvenientService.raise Exceptions::CodePassedAsConstructorArgument.new(selector: selector_from(key), service: service, code: value)
          end

          ##
          # @param key [Integer, Symbol]
          # @param value [Object] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::StatusPassedAsConstructorArgument]
          # @return [void]
          #
          def refute_status!(key, value)
            return unless ::ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.status?(value)

            ::ConvenientService.raise Exceptions::StatusPassedAsConstructorArgument.new(selector: selector_from(key), service: service, status: value)
          end

          ##
          # @param key [Integer, Symbol]
          # @param value [Object] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::StepPassedAsConstructorArgument]
          # @return [void]
          #
          def refute_step!(key, value)
            return unless ::ConvenientService::Plugins::Service::CanHaveSteps.step?(value)

            ::ConvenientService.raise Exceptions::StepPassedAsConstructorArgument.new(selector: selector_from(key), service: service, step: value)
          end

          ##
          # @param key [Integer, Symbol]
          # @return [String]
          #
          def selector_from(key)
            key.instance_of?(::Integer) ? "args[#{key}]" : "kwargs[:#{key}]"
          end
        end
      end
    end
  end
end
