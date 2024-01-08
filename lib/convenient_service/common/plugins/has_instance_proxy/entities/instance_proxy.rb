# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasInstanceProxy
        module Entities
          class InstanceProxy
            ##
            # @param target [Object] Can be any type.
            # @return [void]
            #
            # @internal
            #   TODO: Direct Specs.
            #
            def initialize(target:)
              @__convenient_service_instance_proxy_target__ = target
            end

            ##
            # @return [Object] Can be any type.
            #
            # @internal
            #   TODO: Direct Specs.
            #
            def instance_proxy_target
              @__convenient_service_instance_proxy_target__
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            # @internal
            #   TODO: Direct Specs.
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if instance_proxy_target != other.instance_proxy_target

              true
            end
          end
        end
      end
    end
  end
end
