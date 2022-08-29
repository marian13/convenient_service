# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasCallbacks
        module Entities
          class CallbackCollection
            include Support::Delegate

            attr_reader :callbacks

            delegate :each, :include?, :<<, to: :callbacks

            def initialize
              @callbacks = []
            end

            def for(types)
              callbacks.select { |callback| callback.types.contain_exactly?(types) }
            end

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
