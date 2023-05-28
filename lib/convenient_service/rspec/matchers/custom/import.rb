# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Import
          include ConvenientService::DependencyContainer::Import

          import :"constants.DEFAULT_SCOPE", from: ConvenientService::Support::DependencyContainer::Container
          import :"constants.DEFAULT_PREPEND", from: ConvenientService::Support::DependencyContainer::Container
          import :"commands.FetchImportedScopedMethods", from: ConvenientService::Support::DependencyContainer::Container
          import :"entities.Method", from: ConvenientService::Support::DependencyContainer::Container

          ##
          # @param slug [Symbol, String]
          # @param scope [Symbol]
          # @param from [Class, Module]
          # @param prepend [Boolean]
          # @param as [Symbol, String]
          # @return [void]
          #
          def initialize(slug, from:, as: nil, scope: constants.DEFAULT_SCOPE, prepend: constants.DEFAULT_PREPEND)
            @slug = slug
            @scope = scope
            @from = from
            @prepend = prepend
            @alias_slug = as
          end

          ##
          # @param klass [Class, Module]
          # @return [Boolean]
          #
          def matches?(klass)
            @klass = klass

            method = entities.Method.new(slug: slug, scope: scope, alias_slug: alias_slug)

            namespace = commands.FetchImportedScopedMethods.call(importing_module: klass, scope: scope, prepend: prepend)

            return false unless namespace

            method.defined_in_module?(mod: namespace)
          end

          ##
          # @return [String]
          #
          def description
            "import `#{slug}` as: `#{alias_slug}` with scope: `#{scope}` from: `#{from}` with  prepend: `#{prepend}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{klass}` to import `#{slug}` as: `#{alias_slug}` with scope: `#{scope}` from: `#{from}` with  prepend: `#{prepend}`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{klass}` NOT to import `#{slug}` as: `#{alias_slug}` with scope: `#{scope}` from: `#{from}` with  prepend: `#{prepend}`"
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
          # @!attribute [r] from
          #   @return [Class, Module]
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
