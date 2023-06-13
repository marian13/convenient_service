# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Import
          include ConvenientService::DependencyContainer::Import

          import :"constants.DEFAULT_ALIAS_SLUG", from: ConvenientService::Support::DependencyContainer::Container
          import :"constants.DEFAULT_SCOPE", from: ConvenientService::Support::DependencyContainer::Container
          import :"constants.DEFAULT_PREPEND", from: ConvenientService::Support::DependencyContainer::Container
          import :"commands.GetNamespace", from: ConvenientService::Support::DependencyContainer::Container
          import :"commands.AssertValidContainer", from: ConvenientService::Support::DependencyContainer::Container
          import :"commands.AssertValidScope", from: ConvenientService::Support::DependencyContainer::Container
          import :"commands.AssertValidMethod", from: ConvenientService::Support::DependencyContainer::Container
          import :"entities.Method", from: ConvenientService::Support::DependencyContainer::Container

          ##
          # @param slug [Symbol, String]
          # @param scope [Symbol, Constants::DEFAULT_SCOPE]
          # @param from [Module]
          # @param prepend [Boolean, Constants::DEFAULT_PREPEND]
          # @param as [Symbol, String]
          # @return [void]
          #
          def initialize(slug, from:, as: constants.DEFAULT_ALIAS_SLUG, scope: constants.DEFAULT_SCOPE, prepend: constants.DEFAULT_PREPEND)
            @slug = slug
            @from = from
            @alias_slug = as
            @scope = scope
            @prepend = prepend
          end

          ##
          # @param klass [Class, Module]
          # @return [Boolean]
          #
          def matches?(klass)
            commands.AssertValidContainer.call(container: from)
            commands.AssertValidMethod.call(slug: slug, scope: scope, container: from)
            commands.AssertValidScope.call(scope: scope)

            @klass = klass

            method = entities.Method.new(slug: slug, scope: scope, alias_slug: alias_slug)

            namespace = commands.GetNamespace.call(importing_module: klass, scope: scope, prepend: prepend)

            return false unless namespace

            method.defined_in_module?(namespace)
          end

          ##
          # @return [String]
          #
          def description
            "import `#{slug}`#{printable_alias_slug} with scope: `#{scope}` from: `#{from}` with  prepend: `#{prepend}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{klass}` to import `#{slug}`#{printable_alias_slug} with scope: `#{scope}` from: `#{from}` with  prepend: `#{prepend}`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{klass}` NOT to import `#{slug}`#{printable_alias_slug} with scope: `#{scope}` from: `#{from}` with  prepend: `#{prepend}`"
          end

          private

          ##
          # @return [String]
          #
          def printable_alias_slug
            @printable_alias_slug ||=
              (alias_slug == constants.DEFAULT_ALIAS_SLUG) ? constants.DEFAULT_ALIAS_SLUG : " as: `#{alias_slug}`"
          end

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
          # @!attribute [r] from
          #   @return [Module]
          #
          attr_reader :from

          ##
          # @!attribute [r] prepend
          #   @return [Boolean]
          #
          attr_reader :prepend

          ##
          # @!attribute [r] klass
          #   @return [Class, Module]
          #
          attr_reader :klass

          ##
          # @!attribute [r] alias_slug
          #   @return [String, Symbol]
          #
          attr_reader :alias_slug
        end
      end
    end
  end
end
