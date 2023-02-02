# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasConstructor
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [void]
            #
            def initialize(...)
            end
          end

          class_methods do
            ##
            # @return [Object]
            # @since 0.2.0
            #
            def create(...)
              new(...)
            end
          end
        end
      end
    end
  end
end
