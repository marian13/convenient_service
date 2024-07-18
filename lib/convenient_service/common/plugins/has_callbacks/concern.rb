# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasCallbacks
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api private
            #
            # @return [ConvenientService::Common::Plugins::HasCallbacks::Entities::CallbackCollection]
            #
            def callbacks
              internals_class.cache.fetch(:callbacks) { Entities::CallbackCollection.new }
            end

            ##
            # @api public
            #
            # @param type [Symbol]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback]
            #
            def before(type, &block)
              callbacks.create(types: [:before, type], block: block)
            end

            ##
            # @api public
            #
            # @param type [Symbol]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback]
            #
            def after(type, &block)
              callbacks.create(types: [:after, type], block: block)
            end

            ##
            # @api public
            #
            # @param type [Symbol]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback]
            #
            def around(type, &block)
              callbacks.create(types: [:around, type], block: block)
            end
          end
        end
      end
    end
  end
end
