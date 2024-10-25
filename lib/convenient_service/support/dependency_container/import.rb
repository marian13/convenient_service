# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Import
        include Support::Concern

        class_methods do
          ##
          # @param slug [String, Symbol]
          # @param as [String, Symbol, nil]
          # @param from [Module]
          # @param scope [:instance, :class]
          # @param prepend [Boolean]
          # @return [ConvenientService::Support::DependencyContainer::Entities::Method]
          #
          def import(slug, from:, as: Support::NOT_PASSED, scope: Constants::DEFAULT_SCOPE, prepend: Constants::DEFAULT_PREPEND)
            Commands::AssertValidScope.call(scope: scope)

            Commands::AssertValidContainer.call(container: from)

            Commands::AssertValidMethod.call(slug: slug, scope: scope, container: from)

            method = from.exported_methods.find_by(slug: slug, scope: scope)

            method = method.copy(overrides: {kwargs: {alias_slug: as}}) unless Support::NOT_PASSED[as]

            Commands::ImportMethod.call(importing_module: self, exported_method: method, prepend: prepend)
          end
        end
      end
    end
  end
end
