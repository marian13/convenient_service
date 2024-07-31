# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanNotBeInherited
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @param sub_service_class [Class]
            # @return [void]
            # @raise [ConvenientService::Service::Plugins::CanNotBeInherited::Exceptions::ServiceIsInherited]
            #
            def inherited(sub_service_class)
              ::ConvenientService.raise Exceptions::ServiceIsInherited.new(service_class: self, sub_service_class: sub_service_class)
            end
          end
        end
      end
    end
  end
end
