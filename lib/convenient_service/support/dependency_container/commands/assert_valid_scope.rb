# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class AssertValidScope < Support::Command
          ##
          # @!attribute [r] scope
          #   @return [Object]
          #
          attr_reader :scope

          ##
          # @param scope [Object]
          # @return [void]
          #
          def initialize(scope:)
            @scope = scope
          end

          ##
          # @return [void]
          # @raise [ConvenientService::Support::DependencyContainer::Errors::InvalidScope]
          #
          def call
            raise Errors::InvalidScope.new(scope: scope) unless Constants::SCOPES.include?(scope)
          end
        end
      end
    end
  end
end
