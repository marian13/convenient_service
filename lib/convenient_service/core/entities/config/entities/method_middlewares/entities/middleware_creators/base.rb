# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module MiddlewareCreators
                class Base
                  include Support::Delegate

                  ##
                  # @!attribute [r] middleware
                  #   @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                  #
                  attr_reader :middleware

                  ##
                  # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                  #
                  delegate :to_observable_middleware, to: :middleware

                  ##
                  # @return [void]
                  #
                  # @internal
                  #   TODO: Verbose exception.
                  #
                  def initialize(**kwargs)
                    @middleware = kwargs.fetch(:middleware)
                  end

                  ##
                  # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::With]
                  #
                  def with(...)
                    Entities::MiddlewareCreators::With.new(middleware: self, middleware_arguments: Support::Arguments.new(...))
                  end

                  ##
                  # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Observable]
                  #
                  def observable
                    Entities::MiddlewareCreators::Observable.new(middleware: self)
                  end

                  ##
                  # @param stack [#call<Hash>]
                  # @param kwargs [Hash{Symbol => Object}]
                  # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                  #
                  def new(stack, **kwargs)
                    decorated_middleware.new(stack, **[extra_kwargs, middleware.extra_kwargs, kwargs].reduce(:merge))
                  end

                  ##
                  # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                  #
                  # @note May be overridden by descendants.
                  #
                  def decorated_middleware
                    middleware
                  end

                  ##
                  # @return [Hash{Symbol => Object}]
                  #
                  # @note May be overridden by descendants.
                  #
                  def extra_kwargs
                    {}
                  end

                  ##
                  # @param other [Object]
                  # @return [Boolean, nil]
                  #
                  def ==(other)
                    return unless other.instance_of?(self.class)

                    return false if middleware != other.middleware

                    true
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
