# frozen_string_literal: true

require_relative "concern/instance_methods"
require_relative "concern/class_methods"

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Service
            module Concern
              include Support::Concern

              included do |service_klass|
                service_klass.include Support::Castable

                service_klass.include InstanceMethods

                service_klass.extend ClassMethods
              end
            end
          end
        end
      end
    end
  end
end
