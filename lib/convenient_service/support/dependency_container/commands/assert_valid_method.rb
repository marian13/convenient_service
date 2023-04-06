# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class AssertValidMethod < Support::Command
          ##
          # @!attribute [r] full_name
          #   @return [String, Symbol]
          #
          attr_reader :full_name

          ##
          # @!attribute [r] scope
          #   @return [Symbol]
          #
          attr_reader :scope

          ##
          # @!attribute [r] container
          #   @return [Module]
          #
          attr_reader :container

          ##
          # @param full_name [String, Symbol]
          # @param scope [Symbol]
          # @param container[Module]
          # @return [void]
          #
          def initialize(full_name:, scope:, container:)
            @full_name = full_name
            @scope = scope
            @container = container
          end

          ##
          # @return [void]
          # @raise [ConvenientService::Support::DependencyContainer::Errors::NotExportedMethod]
          #
          def call
            raise Errors::NotExportedMethod.new(method_name: full_name, method_scope: scope, mod: container) unless method
          end

          private

          ##
          # @return [ConvenientService::Support::DependencyContainer::Entities::Method, nil]
          #
          def method
            container.exported_methods.find_by(full_name: full_name, scope: scope)
          end
        end
      end
    end
  end
end
