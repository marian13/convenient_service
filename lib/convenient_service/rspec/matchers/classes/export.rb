# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class Export
          include ConvenientService::DependencyContainer::Import

          import :"constants.DEFAULT_SCOPE", from: ConvenientService::Support::DependencyContainer::Container
          import :"commands.AssertValidContainer", from: ConvenientService::Support::DependencyContainer::Container
          import :"commands.AssertValidScope", from: ConvenientService::Support::DependencyContainer::Container

          ##
          # @param slug [Symbol, String]
          # @param scope [Symbol]
          # @return [void]
          #
          def initialize(slug, scope: constants.DEFAULT_SCOPE)
            @slug = slug
            @scope = scope
          end

          ##
          # @param container [Module]
          # @return [Boolean]
          #
          def matches?(container)
            @container = container

            commands.AssertValidContainer.call(container: container)

            commands.AssertValidScope.call(scope: scope)

            Utils.to_bool(container.exported_methods.find_by(slug: slug, scope: scope))
          end

          ##
          # @return [String]
          #
          def description
            "export `#{slug}` with scope `#{scope}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{container}` to export `#{slug}` with scope `#{scope}`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{container}` NOT to export `#{slug}` with scope `#{scope}`"
          end

          private

          ##
          # @!attribute [r] slug
          #   @return [Symbol, String]
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
        end
      end
    end
  end
end
