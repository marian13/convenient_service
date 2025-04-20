# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Commands
          class CreateResultClass < Support::Command
            include Support::DependencyContainer::Import

            ##
            # @!attribute [r] service_class
            #   @return Class
            #
            attr_reader :service_class

            ##
            # @return Class
            #
            import :"commands.FindOrCreateEntity", from: Common::Plugins::CanHaveUserProvidedEntity::Container

            ##
            # @param service_class [Class]
            # @return [void]
            #
            def initialize(service_class:)
              @service_class = service_class
            end

            ##
            # @return [Class]
            #
            def call
              commands.FindOrCreateEntity.call(namespace: service_class, proto_entity: Entities::Result)
            end
          end
        end
      end
    end
  end
end
