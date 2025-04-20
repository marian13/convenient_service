# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module HasInternals
        module Commands
          class CreateInternalsClass < Support::Command
            include Support::DependencyContainer::Import

            ##
            # @!attribute [r] entity_class
            #   @return Class
            #
            attr_reader :entity_class

            ##
            # @return [Class]
            #
            import :"commands.FindOrCreateEntity", from: Common::Plugins::CanHaveUserProvidedEntity::Container

            ##
            # @param entity_class [Class]
            # @return [void]
            #
            def initialize(entity_class:)
              @entity_class = entity_class
            end

            ##
            # @return [Class]
            #
            def call
              commands.FindOrCreateEntity.call(namespace: entity_class, proto_entity: Entities::Internals)
            end
          end
        end
      end
    end
  end
end
