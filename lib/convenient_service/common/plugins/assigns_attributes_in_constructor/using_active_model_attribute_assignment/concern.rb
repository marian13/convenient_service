# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module AssignsAttributesInConstructor
        module UsingActiveModelAttributeAssignment
          module Concern
            include Support::Concern

            included do |service_class|
              require "active_model"

              service_class.include ::ActiveModel::AttributeAssignment
            end
          end
        end
      end
    end
  end
end
