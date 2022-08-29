# frozen_string_literal: true

require_relative "wrap_method/entities"
require_relative "wrap_method/errors"

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        ##
        # TODO: Specs.
        #
        class WrapMethod < Support::Command
          def initialize(entity, method, middlewares:)
            @entity = entity
            @method = method
            @middlewares = Utils::Array.wrap(middlewares)
          end

          def call
            Entities::WrappedMethod.new(entity: @entity, method: @method, middlewares: @middlewares)
          end
        end
      end
    end
  end
end
