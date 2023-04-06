# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanHaveUserProvidedEntity
        module Errors
          class ProtoEntityHasNoName < ::ConvenientService::Error
            def initialize(proto_entity:)
              message = <<~TEXT
                Proto entity `#{proto_entity}` has no name.

                In other words:

                  proto_entity.name
                  # => nil

                NOTE: Anonymous classes do NOT have names. Are you passing an anonymous class?
              TEXT

              super(message)
            end
          end

          class ProtoEntityHasNoConcern < ::ConvenientService::Error
            def initialize(proto_entity:)
              message = <<~TEXT
                Proto entity `#{proto_entity}` has no concern.

                Have a look at `ConvenientService::Service::Plugins::HasResult::Entities::Result`.

                It is an example of a valid proto entity.
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
