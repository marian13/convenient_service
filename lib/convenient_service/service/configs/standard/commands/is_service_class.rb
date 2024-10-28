# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module Standard
        module Commands
          class IsServiceClass < Support::Command
            ##
            # @!attribute [r] service_class
            #   @return [Object] Can be any type.
            #
            attr_reader :service_class

            ##
            # @param service_class [Object] Can be any type.
            # @return [void]
            #
            def initialize(service_class:)
              @service_class = service_class
            end

            ##
            # @return [Boolean]
            #
            def call
              return unless service_class.instance_of?(::Class)

              service_class.include?(Service::Core)
            end
          end
        end
      end
    end
  end
end
