# frozen_string_literal: true

require_relative "concern/instance_methods"
require_relative "concern/class_methods"

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Concern
          include Support::Concern

          included do |service_class|
            service_class.include InstanceMethods

            service_class.extend ClassMethods
          end
        end
      end
    end
  end
end
