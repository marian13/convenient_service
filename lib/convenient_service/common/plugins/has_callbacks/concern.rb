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
            # @return [ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback]
            #
            def before(type, &block)
              Entities::Callback.new(types: [:before, type], block: block).tap { |callback| callbacks << callback }
            end

            ##
            # @api public
            #
            # @return [ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback]
            #
            def after(type, &block)
              Entities::Callback.new(types: [:after, type], block: block).tap { |callback| callbacks << callback }
            end
          end
        end
      end
    end
  end
end
