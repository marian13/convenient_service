# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasInstanceProxy
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @return [Class] Can be any type.
            #
            def instance_proxy_class
              @instance_proxy_class ||= Commands::CreateInstanceProxyClass[namespace: self]
            end
          end
        end
      end
    end
  end
end
