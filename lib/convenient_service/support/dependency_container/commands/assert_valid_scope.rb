# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
            ::ConvenientService.raise Exceptions::InvalidScope.new(scope: scope) unless Constants::SCOPES.include?(scope)
          end
        end
      end
    end
  end
end
