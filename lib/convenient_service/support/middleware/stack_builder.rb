# frozen_string_literal: true

require_relative "stack_builder/constants"
require_relative "stack_builder/entities"
require_relative "stack_builder/exceptions"

module ConvenientService
  module Support
    module Middleware
      class StackBuilder
        class << self
          ##
          # @param backend [Symbol]
          # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware, ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
          # @raise [ConvenientService::Support::Middleware::StackBuilder::Exceptions::NotSupportedBackend]
          #
          def create(*args, backend: Constants::Backends::DEFAULT, **kwargs)
            case backend
            when Constants::Backends::RUBY_MIDDLEWARE
              Entities::Builders::RubyMiddleware.new(*args, **kwargs)
            when Constants::Backends::RACK
              Entities::Builders::Rack.new(*args, **kwargs)
            else
              ::ConvenientService.raise Exceptions::NotSupportedBackend.new(backend: backend)
            end
          end
        end
      end
    end
  end
end
