# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class CreateMethodsModule < Support::Command
          ##
          # @return [Module]
          #
          def call
            ::Module.new do
              class << self
                ##
                # @return namespaces [ConvenientService::Support::DependencyContainer::Entities::NamespaceCollection]
                #
                def namespaces
                  @namespaces ||= Entities::NamespaceCollection.new
                end
              end
            end
          end
        end
      end
    end
  end
end
