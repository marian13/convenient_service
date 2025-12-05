# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "core/concern"

require_relative "core/constants"
require_relative "core/entities"

require_relative "core/aliases"

module ConvenientService
  module Core
    include Support::Concern

    ##
    # @internal
    #   TODO: Allow to include `Core` only to classes?
    #
    included do
      include Concern

      ##
      # IMPORTANT: Intentionally initializes config (and its mutex) to ensure thread-safety.
      #
      __convenient_service_config__
    end

    class << self
      ##
      # Checks whether an object is a Convenient Service entity class.
      #
      # @api public
      #
      # @param entity_class [Object] Can be any type.
      # @return [Boolean]
      #
      # @example Simple usage.
      #   class Service
      #     include ConvenientService::Standard::Config
      #
      #     def result
      #       success
      #     end
      #   end
      #
      #   service = Service.new
      #
      #   ConvenientService::Core.entity_class?(Service)
      #   # => true
      #
      #   ConvenientService::Core.entity_class?(service)
      #   # => false
      #
      #   ConvenientService::Core.entity?(42)
      #   # => false
      #
      def entity_class?(entity_class)
        return false unless entity_class.instance_of?(::Class)

        entity_class.include?(::ConvenientService::Core)
      end

      ##
      # Checks whether an object is a Convenient Service entity instance.
      #
      # @api public
      #
      # @param entity [Object] Can be any type.
      # @return [Boolean]
      #
      # @example Simple usage.
      #   class Service
      #     include ConvenientService::Standard::Config
      #
      #     def result
      #       success
      #     end
      #   end
      #
      #   service = Service.new
      #
      #   ConvenientService::Core.entity?(service)
      #   # => true
      #
      #   ConvenientService::Core.entity?(Service)
      #   # => false
      #
      #   ConvenientService::Core.entity?(42)
      #   # => false
      #
      def entity?(entity)
        entity_class?(entity.class)
      end
    end
  end
end
