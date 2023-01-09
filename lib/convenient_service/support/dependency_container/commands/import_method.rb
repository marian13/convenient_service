# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class ImportMethod < Support::Command
          ##
          # @!attribute [r] importing_module
          #   @return [Module]
          #
          attr_reader :importing_module

          ##
          # @!attribute [r] exporting_module
          #   @return [Module]
          #
          attr_reader :exporting_module

          ##
          # @!attribute [r] method
          #   @return [ConvenientService::Support::DependencyContainer::Method]
          #
          attr_reader :method

          ##
          # @!attribute [r] scope
          #   @return [Symbol]
          #
          attr_reader :scope

          ##
          # @!attribute [r] prepend
          #   @return [Boolean]
          #
          attr_reader :prepend

          ##
          # @param importing_module [Module]
          # @param exporting_module [Module]
          # @param method [ConvenientService::Support::DependencyContainer::Method]
          # @param scope [:instance, :class]
          # @param prepend [Boolean]
          #
          def initialize(importing_module:, exporting_module:, method:, scope:, prepend:)
            @importing_module = importing_module
            @exporting_module = exporting_module
            @method = method
            @scope = scope
            @prepend = prepend
          end

          ##
          # @param mod [ConvenientService::Support::DependencyContainer::Method]
          # @return [ConvenientService::Support::DependencyContainer::Method]
          #
          def call
            import imported_scoped_methods

            method.define_in_module!(imported_scoped_methods)

            method
          end

          private

          ##
          # @return [Module]
          #
          def imported_scoped_methods
            @imported_scoped_methods ||= Utils::Module.fetch_own_const(importing_module, :"Imported#{imported_prefix}#{scoped_prefix}Methods") { ::Module.new }
          end

          ##
          # @return [String]
          #
          def imported_prefix
            prepend ? "Prepended" : "Included"
          end

          ##
          # @return [String]
          #
          def scoped_prefix
            case scope
            when Constants::INSTANCE_SCOPE then "Instance"
            when Constants::CLASS_SCOPE then "Class"
            end
          end

          ##
          # @return [Module, Class]
          #
          def importer
            case scope
            when Constants::INSTANCE_SCOPE then importing_module
            when Constants::CLASS_SCOPE then importing_module.singleton_class
            end
          end

          ##
          # @param mod [Module]
          # @return [Module]
          #
          def import(mod)
            prepend ? importer.prepend(mod) : importer.include(mod)
          end
        end
      end
    end
  end
end
