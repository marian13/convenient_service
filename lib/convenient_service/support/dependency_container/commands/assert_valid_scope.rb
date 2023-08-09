# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class AssertValidScope < Support::Command
          ##
          # @!attribute [r] scope
          #   @return [Symbol]
          #
          attr_reader :scope

          ##
          # @param scope [Symbol]
          # @return [void]
          #
          def initialize(scope:)
            @scope = scope
          end

          ##
          # @return [void]
          # @raise [ConvenientService::Support::DependencyContainer::Exceptions::InvalidScope]
          #
          def call
            raise Exceptions::InvalidScope.new(scope: scope) unless Constants::SCOPES.include?(scope)
          end
        end
      end
    end
  end
end
