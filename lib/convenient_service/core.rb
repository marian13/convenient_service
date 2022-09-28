# frozen_string_literal: true

require_relative "core/instance_methods"
require_relative "core/class_methods"

require_relative "core/entities"

require_relative "core/aliases"

module ConvenientService
  module Core
    include Support::Concern

    included do |service_class|
      service_class.include InstanceMethods
      service_class.extend ClassMethods
    end
  end
end
