# frozen_string_literal: true

require_relative "concern/instance_methods"
require_relative "concern/class_methods"

module ConvenientService
  module Core
    module Concern
      include Support::Concern

      included do |entity_class|
        entity_class.include InstanceMethods

        entity_class.extend ClassMethods
      end
    end
  end
end
