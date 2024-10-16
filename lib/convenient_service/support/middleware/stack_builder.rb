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
          # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware, ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack]
          #
          def new(...)
            backed_by(Constants::Backends::DEFAULT).new(...)
          end

          ##
          # @param backend [Symbol]
          # @return [Class]
          # @raise [ConvenientService::Support::Middleware::StackBuilder::Exceptions::NotSupportedBackend]
          #
          def backed_by(backend)
            case backend
            when Constants::Backends::RUBY_MIDDLEWARE
              Entities::Builders::RubyMiddleware
            when Constants::Backends::RACK
              Entities::Builders::Rack
            when Constants::Backends::STATEFUL
              Entities::Builders::Stateful
            else
              ::ConvenientService.raise Exceptions::NotSupportedBackend.new(backend: backend)
            end
          end
        end
      end
    end
  end
end
