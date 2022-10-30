# frozen_string_literal: true

require_relative "config/entities"

module ConvenientService
  module Core
    module Entities
      class Config
        ##
        # @!attribute [r] klass
        #   @return [Class]
        #
        attr_reader :klass

        ##
        # @param klass [Class]
        # @return [void]
        #
        def initialize(klass:)
          @klass = klass
        end

        ##
        # Sets or gets concerns for a service class.
        #
        # @overload concerns
        #   Returns all concerns.
        #   @return [ConvenientService::Core::Entities::Config::Entities::Concerns]
        #
        # @overload concerns(&configuration_block)
        #   Configures concerns.
        #   @param configuration_block [Proc] Block that configures middlewares.
        #   @see https://github.com/marian13/ruby-middleware#a-basic-example
        #   @return [ConvenientService::Core::Entities::Config::Entities::Concerns]
        #
        # @example Getter
        #   concerns
        #
        # @example Setter
        #   concerns(&configuration_block)
        #
        def concerns(&configuration_block)
          if configuration_block
            @concerns ||= Entities::Concerns.new(klass: klass)
            @concerns.assert_not_included!
            @concerns.configure(&configuration_block)
          end

          @concerns || Entities::Concerns.new(klass: klass)
        end

        ##
        # Sets or gets middlewares for a service class.
        #
        # @overload middlewares(method)
        #   Returns all instance middlewares for particular method.
        #   @param method [Symbol] Method name.
        #   @return [Hash<Symbol, Hash<Symbol, ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares>>]
        #
        # @overload middlewares(method, scope:)
        #   Returns all scoped middlewares for particular method.
        #   @param method [Symbol] Method name.
        #   @param scope [:instance, :class]
        #   @return [Hash<Symbol, Hash<Symbol, ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares>>]
        #
        # @overload middlewares(method, &configuration_block)
        #   Configures instance middlewares for particular method.
        #   @param method [Symbol] Method name.
        #   @param configuration_block [Proc] Block that configures middlewares.
        #   @see https://github.com/marian13/ruby-middleware#a-basic-example
        #   @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares]
        #
        # @overload middlewares(method, scope:, &configuration_block)
        #   Configures scoped middlewares for particular method.
        #   @param method [Symbol] Method name.
        #   @param scope [:instance, :class]
        #   @param configuration_block [Proc] Block that configures middlewares.
        #   @see https://github.com/marian13/ruby-middleware#a-basic-example
        #   @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares]
        #
        # @example Getters
        #   middlewares(:result)
        #   middlewares(:result, scope: :instance)
        #   middlewares(:result, scope: :class)
        #
        # @example Setters
        #   middlewares(:result, &configuration_block)
        #   middlewares(:result, scope: :instance, &configuration_block)
        #   middlewares(:result, scope: :class, &configuration_block)
        #
        def middlewares(method, scope: :instance, &configuration_block)
          @middlewares ||= {}
          @middlewares[scope] ||= {}

          if configuration_block
            @middlewares[scope][method] ||= Entities::MethodMiddlewares.new(scope: scope, method: method, klass: klass)
            @middlewares[scope][method].configure(&configuration_block)
            @middlewares[scope][method].define!
          end

          @middlewares[scope][method] || Entities::MethodMiddlewares.new(scope: scope, method: method, klass: klass)
        end

        ##
        # @return [void]
        #
        def commit!
          concerns.include!
        end
      end
    end
  end
end
