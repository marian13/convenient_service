# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class AssertValidContainer < Support::Command
          ##
          # @!attribute [r] from
          #   @return [Object]
          #
          attr_reader :from

          ##
          # @param from [Object]
          # @return [void]
          #
          def initialize(from:)
            @from = from
          end

          ##
          # @return [void]
          # @raise [ConvenientService::Support::DependencyContainer::Errors::NotExportableModule]
          #
          def call
            raise Errors::NotExportableModule.new(mod: from) unless Utils::Module.include_module?(from, DependencyContainer::Export)
          end
        end
      end
    end
  end
end
