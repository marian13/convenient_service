# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Import
        include Support::Concern

        class_methods do
          ##
          # @param full_name [String, Symbol]
          # @param as [String, Symbol]
          # @param from [Module]
          # @param scope [:instance, :class]
          # @param prepend [Boolean]
          # @return [ConvenientService::Support::DependencyContainer::Entities::Method]
          #
          def import(full_name, as: nil, from:, scope: Constants::DEFAULT_SCOPE, prepend: Constants::DEFAULT_PREPEND)
            Commands::AssertValidScope.call(scope: scope)

            Commands::AssertValidContainer.call(container: from)

            Commands::AssertValidMethod.call(full_name: full_name, scope: scope, container: from)

            method = from.exported_methods.find_by(full_name: full_name, scope: scope)

            method = method.copy(overrides: {kwargs: {alias_slug: as}}) if as

            Commands::ImportMethod.call(importing_module: self, exported_method: method, prepend: prepend)
          end
        end
      end
    end
  end
end
