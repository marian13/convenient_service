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
            # @param kwargs [Hash{Symbol => Object}]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
            #
            def before(method, **kwargs, &block)
              callback(:before, method, **kwargs, &block)
            end

            ##
            # @api public
            #
            # @param method [Symbol]
            # @param kwargs [Hash{Symbol => Object}]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
            #
            def after(method, **kwargs, &block)
              callback(:after, method, **kwargs, &block)
            end

            ##
            # @api public
            #
            # @param method [Symbol]
            # @param kwargs [Hash{Symbol => Object}]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
            #
            def around(method, **kwargs, &block)
              callback(:around, method, **kwargs, &block)
            end

            ##
            # @api public
            #
            # @param type [Symbol]
            # @param method [Symbol]
            # @param kwargs [Hash{Symbol => Object}]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
            #
            def callback(type, method, **kwargs, &block)
              callbacks.create(types: [type, method], block: block, **kwargs)
            end
          end
        end
      end
    end
  end
end
