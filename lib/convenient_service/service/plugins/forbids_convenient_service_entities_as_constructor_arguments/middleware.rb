# frozen_string_literal: true

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
            args.each_with_index { |value, index| validate!(:args, index, value) }

            kwargs.each_pair { |key, value| validate!(:kwargs, key, value) }

            chain.next(*args, **kwargs, &block)
          end

          private

          ##
          # @param collection_type [Symbol]
          # @param key [Integer, Symbol]
          # @param value [Object] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ServicePassedAsConstructorArgument, ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ResultPassedAsConstructorArgument, ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::StepPassedAsConstructorArgument]
          # @return [void]
          #
          def validate!(collection_type, key, value)
            refute_service!(collection_type, key, value)
            refute_result!(collection_type, key, value)
            refute_step!(collection_type, key, value)
          end

          ##
          # @param collection_type [Symbol]
          # @param key [Integer, Symbol]
          # @param value [Object] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ServicePassedAsConstructorArgument]
          # @return [void]
          #
          def refute_service!(collection_type, key, value)
            return unless ::ConvenientService.service?(value)

            ::ConvenientService.raise Exceptions::ServicePassedAsConstructorArgument.new(selector: selector_from(collection_type, key), service: service, other_service: value)
          end

          ##
          # @param collection_type [Symbol]
          # @param key [Integer, Symbol]
          # @param value [Object] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ResultPassedAsConstructorArgument]
          # @return [void]
          #
          def refute_result!(collection_type, key, value)
            return unless ::ConvenientService::Plugins::Service::HasJSendResult.result?(value)

            ::ConvenientService.raise Exceptions::ResultPassedAsConstructorArgument.new(selector: selector_from(collection_type, key), service: service, result: value)
          end

          ##
          # @param collection_type [Symbol]
          # @param key [Integer, Symbol]
          # @param value [Object] Can be any type.
          # @raise [ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::StepPassedAsConstructorArgument]
          # @return [void]
          #
          def refute_step!(collection_type, key, value)
            return unless ::ConvenientService::Plugins::Service::CanHaveSteps.step?(value)

            ::ConvenientService.raise Exceptions::StepPassedAsConstructorArgument.new(selector: selector_from(collection_type, key), service: service, step: value)
          end

          ##
          # @param collection_type [Symbol]
          # @param key [Integer, Symbol]
          # @return [String]
          #
          def selector_from(collection_type, key)
            "#{collection_type}[#{key.inspect}]"
          end
        end
      end
    end
  end
end
