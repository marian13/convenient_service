# frozen_string_literal: true

module ConvenientService
  module Core
    module Concern
      module SingletonClassMethods
        ##
        # @api private
        #
        # @return [ConvenientService::Core::Entities::Config]
        #
        # @internal
        #   NOTE: The instance variable is named `@__convenient_service_config__` intentionally in order to decrease the possibility of accidental redefinition by the end-user.
        #
        if Dependencies.ruby.version >= 3.2
          def __convenient_service_config__
            attached_object.__convenient_service_config__
          end
        else
          def __convenient_service_config__(klass: nil)
            @__convenient_service_config__ ||= Entities::Config.new(klass: klass)
          end
        end
      end
    end
  end
end
