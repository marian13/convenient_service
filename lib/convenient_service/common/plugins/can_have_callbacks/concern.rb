# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanHaveCallbacks
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api private
            #
            # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::CallbackCollection]
            #
            def callbacks
              internals_class.cache.fetch(:callbacks) { Entities::CallbackCollection.new }
            end

            ##
            # @api public
            #
            # @param method [Symbol]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
            #
            def before(method, &block)
              callback(:before, method, &block)
            end

            ##
            # @api public
            #
            # @param method [Symbol]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
            #
            def after(method, &block)
              callback(:after, method, &block)
            end

            ##
            # @api public
            #
            # @param method [Symbol]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
            #
            def around(method, &block)
              callback(:around, method, &block)
            end

            ##
            # @api public
            #
            # @param type [Symbol]
            # @param method [Symbol]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
            #
            def callback(type, method, &block)
              callbacks.create(types: [type, method], block: block)
            end
          end
        end
      end
    end
  end
end
