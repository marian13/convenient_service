# frozen_string_literal: true

module ConvenientService
  module Core
    module ClassMethods
      ##
      # Sets or gets concerns for a service class.
      #
      # @overload concerns
      #   Returns all concerns.
      #   @return [ConvenientService::Core::Entities::Concerns]
      #
      # @overload concerns(&configuration_block)
      #   Configures concerns.
      #   @param configuration_block [Proc] Block that configures middlewares.
      #   @see https://github.com/marian13/ruby-middleware#a-basic-example
      #   @return [ConvenientService::Core::Entities::Concerns]
      #
      # @example Getter
      #   concerns
      #
      # @example Setter
      #   concerns(&configuration_block)
      #
      def concerns(&configuration_block)
        @concerns ||= Entities::Concerns.new(entity: self)

        return @concerns unless configuration_block

        @concerns.assert_not_included!

        @concerns.configure(&configuration_block)

        @concerns
      end

      ##
      # Sets or gets middlewares for a service class.
      #
      # @overload middlewares
      #   Returns all instance middewares.
      #   @return [Hash<Symbol, Hash<Symbol, ConvenientService::Core::Entities::MethodMiddlewares>>]
      #
      # @overload middlewares(scope:)
      #   Returns all scoped middewares.
      #   @param scope [:instance, :class]
      #   @return [Hash<Symbol, Hash<Symbol, ConvenientService::Core::Entities::MethodMiddlewares>>]
      #
      # @overload middlewares(method:)
      #   Returns all instance middlewares for particular method.
      #   @param method [Symbol] Method name.
      #   @return [Hash<Symbol, Hash<Symbol, ConvenientService::Core::Entities::MethodMiddlewares>>]
      #
      # @overload middlewares(method:, scope:)
      #   Returns all scoped middlewares for particular method.
      #   @param method [Symbol] Method name.
      #   @param scope [:instance, :class]
      #   @return [Hash<Symbol, Hash<Symbol, ConvenientService::Core::Entities::MethodMiddlewares>>]
      #
      # @overload middlewares(method:, &configuration_block)
      #   Configures instance middlewares for particular method.
      #   @param method [Symbol] Method name.
      #   @param configuration_block [Proc] Block that configures middlewares.
      #   @see https://github.com/marian13/ruby-middleware#a-basic-example
      #   @return [ConvenientService::Core::Entities::MethodMiddlewares]
      #
      # @overload middlewares(method:, scope:, &configuration_block)
      #   Configures scoped middlewares for particular method.
      #   @param method [Symbol] Method name.
      #   @param scope [:instance, :class]
      #   @param configuration_block [Proc] Block that configures middlewares.
      #   @see https://github.com/marian13/ruby-middleware#a-basic-example
      #   @return [ConvenientService::Core::Entities::MethodMiddlewares]
      #
      # @example Getters
      #   middlewares
      #   middlewares(scope: :instance)
      #   middlewares(scope: :class)
      #   middlewares(method: :result)
      #   middlewares(method: :result, scope: :instance)
      #   middlewares(method: :result, scope: :class)
      #
      # @example Setters
      #   middlewares(method: :result, &configuration_block)
      #   middlewares(method: :result, scope: :instance, &configuration_block)
      #   middlewares(method: :result, scope: :class, &configuration_block)
      #
      def middlewares(**kwargs, &configuration_block)
        scope = kwargs[:scope] || :instance
        method = kwargs[:method] || (raise ::ArgumentError if configuration_block)
        container = self

        @middlewares ||= {}

        @middlewares[scope] ||= {}

        ##
        # NOTE: Setter.
        #
        if configuration_block
          @middlewares[scope][method] ||= Entities::MethodMiddlewares.new(scope: scope, method: method, container: container)

          @middlewares[scope][method].configure(&configuration_block)

          @middlewares[scope][method].define!

          return @middlewares[scope][method]
        end

        ##
        # NOTE: Getter
        #
        return @middlewares[scope] unless method

        @middlewares[scope][method]
      end

      ##
      # @return [void]
      #
      def commit_config!
        concerns.include!

        ConvenientService.logger.debug { "[Core] Included concerns into `#{self}` | Triggered by `.commit_config!`" }

        middlewares(scope: :instance).values.each(&:define!)
        middlewares(scope: :class).values.each(&:define!)
      end

      private

      ##
      # Includes `concerns` into the mixing class.
      # If `method` is still NOT defined, raises `NoMethodError`, otherwise - retries to call the `method`.
      #
      # @param method [Symbol]
      # @param args [Array<Object>]
      # @param kwargs [Hash<Symbol, Object>]
      # @param block [Proc]
      # @return [void]
      #
      # @internal
      #   IMPORTANT: `method_missing` should be thread-safe.
      #
      def method_missing(method, *args, **kwargs, &block)
        concerns.include!

        return super unless Utils::Method.defined?(method, singleton_class, private: true)

        ConvenientService.logger.debug { "[Core] Included concerns into `#{self}` | Triggered by `method_missing` | Method: `.#{method}`" }

        __send__(method, *args, **kwargs, &block)
      end

      ##
      # TODO: How?
      #
      # TODO: Implement.
      # https://thoughtbot.com/blog/always-define-respond-to-missing-when-overriding
      #
      def respond_to_missing?(method_name, include_private = false)
        false
      end
    end
  end
end
