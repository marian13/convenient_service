# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "can_have_user_provided_entity/commands"
require_relative "can_have_user_provided_entity/exceptions"

module ConvenientService
  module Common
    module Plugins
      module CanHaveUserProvidedEntity
        class << self
          def find_or_create_entity(namespace, proto_entity)
            Commands::FindOrCreateEntity[namespace: namespace, proto_entity: proto_entity]
          end
        end
      end
    end
  end
end
