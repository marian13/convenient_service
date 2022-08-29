# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasAroundCallbacks
        module Concern
          include Support::Concern

          class_methods do
            def around(type, &block)
              Plugins::HasCallbacks::Entities::Callback.new(types: [:around, type], block: block).tap { |callback| callbacks << callback }
            end
          end
        end
      end
    end
  end
end
