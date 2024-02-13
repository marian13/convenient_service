# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasAroundCallbacks
        module Concern
          include Support::Concern

          class_methods do
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
