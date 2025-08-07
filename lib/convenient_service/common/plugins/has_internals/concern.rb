# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module HasInternals
        module Concern
          include Support::Concern

          instance_methods do
            def internals
              @internals ||= self.class.internals_class.new
            end
          end

          class_methods do
            def internals_class
              @internals_class ||= Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity[
                namespace: self,
                proto_entity: Entities::Internals
              ]
            end
          end
        end
      end
    end
  end
end
