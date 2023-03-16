# frozen_string_literal: true

require_relative "concern/instance_methods"

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Concern
              include Support::Concern

              included do |step_class|
                step_class.include InstanceMethods
              end
            end
          end
        end
      end
    end
  end
end
