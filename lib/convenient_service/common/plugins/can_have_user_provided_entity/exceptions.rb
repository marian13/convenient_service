# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module CanHaveUserProvidedEntity
        module Exceptions
          class ProtoEntityHasNoName < ::ConvenientService::Exception
            def initialize_with_kwargs(proto_entity:)
              message = <<~TEXT
                Proto entity `#{proto_entity}` has no name.

                In other words:

                  proto_entity.name
                  # => nil

                NOTE: Anonymous classes do NOT have names. Are you passing an anonymous class?
              TEXT

              initialize(message)
            end
          end

          class ProtoEntityHasNoConcern < ::ConvenientService::Exception
            def initialize_with_kwargs(proto_entity:)
              message = <<~TEXT
                Proto entity `#{proto_entity}` has no concern.

                Have a look at `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result`.

                It is an example of a valid proto entity.
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
