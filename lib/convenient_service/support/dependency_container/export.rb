# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Export
        include Support::Concern

        class_methods do
          ##
          # @param full_name [String, Symbol]
          # @param scope [:instance, :class]
          # @param body [Proc]
          # @return [ConvenientService::Support::DependencyContainer::Entities::Method]
          #
          def export(full_name, scope: Constants::DEFAULT_SCOPE, &body)
            exported_methods << Entities::Method.new(full_name: full_name, scope: scope, body: body)
          end

          ##
          # @return [ConvenientService::Support::DependencyContainer::Entities::MethodCollection]
          #
          def exported_methods
            @exported_methods ||= Entities::MethodCollection.new
          end
        end
      end
    end
  end
end
