# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module AssignsAttributesInConstructor
        module UsingDryInitializer
          module Concern
            include Support::Concern

            included do |service_class|
              service_class.extend ::Dry::Initializer
            end
          end
        end
      end
    end
  end
end
