# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class AssertValidContainer < Support::Command
          ##
          # @!attribute [r] container
          #   @return [Module]
          #
          attr_reader :container

          ##
          # @param container [Module]
          # @return [void]
          #
          def initialize(container:)
            @container = container
          end

          ##
          # @return [void]
          # @raise [ConvenientService::Support::DependencyContainer::Exceptions::NotExportableModule]
          #
          def call
            raise Exceptions::NotExportableModule.new(mod: container) unless Utils::Module.include_module?(container, DependencyContainer::Export)
          end
        end
      end
    end
  end
end
