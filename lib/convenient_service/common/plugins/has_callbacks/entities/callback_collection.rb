# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasCallbacks
        module Entities
          class CallbackCollection
            include ::Enumerable

            include Support::Delegate

            ##
            # @api private
            #
            # @!attribute [r] types
            #   @return [ConvenientService::Common::Plugins::HasCallbacks::Entities::TypeCollection]
            #
            attr_reader :callbacks

            ##
            # @api private
            #
            # @return [Array<ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback>]
            #
            delegate :each, to: :callbacks

            ##
            # @api private
            #
            # @return [void]
            #
            def initialize
              @callbacks = []
            end

            ##
            # @return [Class<ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback>]
            #
            def callback_class
              Entities::Callback
            end

            ##
            # @api private
            #
            # @param types [Array<Symbol>]
            # @return [Array<ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback>]
            #
            def for(types)
              callbacks.select { |callback| callback.types.contain_exactly?(types) }
            end

            ##
            # @api private
            #
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback]
            #
            def create(**kwargs)
              Entities::Callback.new(**kwargs)
                .tap { |callback| callbacks << callback }
            end

            ##
            # @api private
            #
            # @param other [Object] Can be any type.
            # @return [Boolean]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if callbacks != other.callbacks

              true
            end
          end
        end
      end
    end
  end
end
