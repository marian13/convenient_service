# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Import
        include Support::Concern

        class_methods do
          ##
          # @param full_name [String, Symbol]
          # @param from [Module]
          # @param scope [:instance, :class]
          # @param prepend [Boolean]
          # @return [ConvenientService::Support::DependencyContainer::Entities::Method]
          #
          def import(full_name, from:, scope: Constants::DEFAULT_SCOPE, prepend: Constants::DEFAULT_PREPEND)
            raise Errors::NotExportableModule.new(mod: from) unless Utils::Module.include_module?(from, DependencyContainer::Export)

            method = from.exported_methods.find_by(full_name: full_name, scope: scope)

            raise Errors::NotExportedMethod.new(method_name: full_name, method_scope: scope, mod: from) unless method

            Commands::ImportMethod.call(importing_module: self, exported_method: method, prepend: prepend)
          end
        end
      end
    end
  end
end
