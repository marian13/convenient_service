# frozen_string_literal: true

require_relative "core/instance_methods"
require_relative "core/class_methods"

require_relative "core/commands"
require_relative "core/entities"
require_relative "core/errors"

module ConvenientService
  module Core
    ##
    # Aliases.
    #
    ClassicMiddleware = Entities::ClassicMiddleware
    ConcernMiddleware = Entities::Concerns::ConcernMiddleware
    MethodChainMiddleware = Entities::Middlewares::MethodChainMiddleware

    include Support::Concern

    included do |service_class|
      service_class.include InstanceMethods
      service_class.extend ClassMethods
    end
  end
end
