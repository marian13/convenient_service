# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        class WrapMethod < Support::Command
          module Entities
            ##
            # @internal
            #   TODO: A better name.
            #
            #   NOTE: Do NOT pollute the interface of this class until really needed. Avoid even pollution of private methods.
            #
            class WrappedMethod
              ##
              # @!attribute [r] entity
              #   @return [Object] Can be any type.
              #
              attr_reader :entity

              ##
              # @!attribute [r] method
              #   @return [Symbol, String]
              #
              attr_reader :method

              ##
              # @!attribute [r] observe_middleware
              #   @return [Class]
              #
              attr_reader :observe_middleware

              ##
              # @param entity [Object] Can be any type.
              # @param method [String]
              # @param observe_middleware [Class]
              # @return [void]
              #
              def initialize(entity:, method:, observe_middleware:)
                @entity = entity
                @method = method
                @observe_middleware = observe_middleware

                ##
                # TODO: When middleware is NOT used yet.
                #
                observable_middleware.middleware_events[:before_chain_next].add_observer(self)
                observable_middleware.middleware_events[:after_chain_next].add_observer(self)

                ##
                # TODO: Consider `ObjectSpace.define_finalizer`? Is it really needed?
                #
                # observable_middleware.middleware_events[:before_chain_next].delete_observer(self)
                # observable_middleware.middleware_events[:after_chain_next].delete_observer(self)
              end

              ##
              # @internal
              #   NOTE: The following handler is triggered only when `chain.next` is called from method chain middleware.
              #
              def handle_before_chain_next(arguments)
                @chain_called = true
                @chain_arguments = arguments
              end

              ##
              # @internal
              #   NOTE: The following handler is triggered only when `chain.next` is called from method chain middleware.
              #
              def handle_after_chain_next(value, _arguments)
                @chain_value = value
              end

              ##
              # @return [String]
              #
              def scope
                @scope ||= Utils::Object.resolve_type(entity).to_sym
              end

              ##
              # @return [Class]
              #
              def klass
                @klass ||= Utils::Object.clamp_class(entity)
              end

              ##
              # @return [Class]
              #
              def observable_middleware
                @observable_middleware ||= klass.middlewares(method, scope: scope).to_a.find { |other| other == observe_middleware.observable }
              end

              ##
              # @param args [Array<Object>]
              # @param kwargs [Hash{Symbol => Object}]
              # @param block [Proc, nil]
              # @return [Object] Can be any type.
              #
              def call(*args, **kwargs, &block)
                entity.__send__(method, *args, **kwargs, &block)
              rescue => exception
                @chain_exception = exception

                ##
                # NOTE: `raise` with no args inside `rescue` reraises rescued exception.
                #
                raise
              end

              ##
              # @return [void]
              #
              def reset!
                remove_instance_variable(:@chain_called) if defined? @chain_called
                remove_instance_variable(:@chain_value) if defined? @chain_value
                remove_instance_variable(:@chain_arguments) if defined? @chain_arguments
                remove_instance_variable(:@chain_exception) if defined? @chain_exception
              end

              ##
              # @return [Boolean]
              #
              def chain_called?
                Utils.to_bool(defined? @chain_called)
              end

              ##
              # @return [Object] Can be any type.
              # @raise [ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess]
              #
              def chain_value
                ::ConvenientService.raise Exceptions::ChainAttributePreliminaryAccess.new(attribute: :value) unless chain_called?

                @chain_value
              end

              ##
              # @return [Array]
              # @raise [ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess]
              #
              def chain_args
                ::ConvenientService.raise Exceptions::ChainAttributePreliminaryAccess.new(attribute: :args) unless chain_called?

                @chain_arguments.args
              end

              ##
              # @return [Hash]
              # @raise [ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess]
              #
              def chain_kwargs
                ::ConvenientService.raise Exceptions::ChainAttributePreliminaryAccess.new(attribute: :kwargs) unless chain_called?

                @chain_arguments.kwargs
              end

              ##
              # @return [Proc, nil]
              # @raise [ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess]
              #
              def chain_block
                ::ConvenientService.raise Exceptions::ChainAttributePreliminaryAccess.new(attribute: :block) unless chain_called?

                @chain_arguments.block
              end

              ##
              # @return [StandardError, nil]
              # @raise [ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions::ChainAttributePreliminaryAccess]
              #
              def chain_exception
                ::ConvenientService.raise Exceptions::ChainAttributePreliminaryAccess.new(attribute: :exception) unless chain_called?

                @chain_exception
              end

              ##
              # @param other [Object] Can be any type.
              # @return [Boolean, nil]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if entity != other.entity
                return false if method != other.method
                return false if observe_middleware != other.observe_middleware

                true
              end
            end
          end
        end
      end
    end
  end
end
