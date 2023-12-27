# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class AssertValidMethod < Support::Command
          ##
          # @!attribute [r] slug
          #   @return [String, Symbol]
          #
          attr_reader :slug

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
          # @param slug [String, Symbol]
          # @param scope [Symbol]
          # @param container[Module]
          # @return [void]
          #
          def initialize(slug:, scope:, container:)
            @slug = slug
            @scope = scope
            @container = container
          end

          ##
          # @return [void]
          # @raise [ConvenientService::Support::DependencyContainer::Exceptions::NotExportedMethod]
          #
          def call
            ::ConvenientService.raise Exceptions::NotExportedMethod.new(method_name: slug, method_scope: scope, mod: container) unless method
          end

          private

          ##
          # @return [ConvenientService::Support::DependencyContainer::Entities::Method, nil]
          #
          def method
            container.exported_methods.find_by(slug: slug, scope: scope)
          end
        end
      end
    end
  end
end
