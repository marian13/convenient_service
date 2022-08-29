# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasCallbacks
        module Concern
          include Support::Concern

          instance_methods do
            include Support::Delegate

            delegate :callbacks, to: :class
          end

          class_methods do
            def callbacks
              @callbacks ||= Entities::CallbackCollection.new
            end

            def before(type, &block)
              Entities::Callback.new(types: [:before, type], block: block).tap { |callback| callbacks << callback }
            end

            def after(type, &block)
              Entities::Callback.new(types: [:after, type], block: block).tap { |callback| callbacks << callback }
            end
          end
        end
      end
    end
  end
end
