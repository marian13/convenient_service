# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module Standard
        module Commands
          class IsService < Support::Command
            ##
            # @!attribute [r] service
            #   @return [Object] Can be any type.
            #
            attr_reader :service

            ##
            # @param service [Object] Can be any type.
            # @return [void]
            #
            def initialize(service:)
              @service = service
            end

            ##
            # @return [Boolean]
            #
            def call
              Commands::IsServiceClass[service_class: service.class]
            end
          end
        end
      end
    end
  end
end
