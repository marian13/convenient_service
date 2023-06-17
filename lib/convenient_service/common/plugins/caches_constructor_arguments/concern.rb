# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CachesConstructorArguments
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [ConvenientService::Support::Arguments]
            #
            def constructor_arguments
              internals.cache[:constructor_arguments] || Support::Arguments.null_arguments
            end
          end
        end
      end
    end
  end
end
