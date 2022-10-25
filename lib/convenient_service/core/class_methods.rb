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
        if configuration_block
          @concerns ||= Entities::Concerns.new(entity: self)
          @concerns.assert_not_included!
          @concerns.configure(&configuration_block)
        end

        @concerns || Entities::Concerns.new(entity: self)
      end

      ##
      # Sets or gets middlewares for a service class.
      #
      # @overload middlewares(method)
      #   Returns all instance middlewares for particular method.
      #   @param method [Symbol] Method name.
      #   @return [Hash<Symbol, Hash<Symbol, ConvenientService::Core::Entities::MethodMiddlewares>>]
      #
      # @overload middlewares(method, scope:)
      #   Returns all scoped middlewares for particular method.
      #   @param method [Symbol] Method name.
      #   @param scope [:instance, :class]
      #   @return [Hash<Symbol, Hash<Symbol, ConvenientService::Core::Entities::MethodMiddlewares>>]
      #
      # @overload middlewares(method, &configuration_block)
      #   Configures instance middlewares for particular method.
      #   @param method [Symbol] Method name.
      #   @param configuration_block [Proc] Block that configures middlewares.
      #   @see https://github.com/marian13/ruby-middleware#a-basic-example
      #   @return [ConvenientService::Core::Entities::MethodMiddlewares]
      #
      # @overload middlewares(method, scope:, &configuration_block)
      #   Configures scoped middlewares for particular method.
      #   @param method [Symbol] Method name.
      #   @param scope [:instance, :class]
      #   @param configuration_block [Proc] Block that configures middlewares.
      #   @see https://github.com/marian13/ruby-middleware#a-basic-example
      #   @return [ConvenientService::Core::Entities::MethodMiddlewares]
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
          @middlewares[scope][method] ||= Entities::MethodMiddlewares.new(scope: scope, method: method, klass: self)
          @middlewares[scope][method].configure(&configuration_block)
          @middlewares[scope][method].define!
        end

        @middlewares[scope][method] || Entities::MethodMiddlewares.new(scope: scope, method: method, klass: self)
      end

      ##
      # @return [void]
      #
      def commit_config!
        concerns.include!

        ConvenientService.logger.debug { "[Core] Included concerns into `#{self}` | Triggered by `.commit_config!`" }
      end

      ##
      # @see https://thoughtbot.com/blog/always-define-respond-to-missing-when-overriding
      # @see https://stackoverflow.com/a/3304683/12201472
      #
      # @param method_name [Symbol, String]
      # @param include_private [Boolean]
      # @return [Boolean]
      #
      def respond_to_missing?(method_name, include_private = false)
        return true if singleton_class.method_defined?(method_name)
        return true if concerns.class_method_defined?(method_name)

        if include_private
          return true if singleton_class.private_method_defined?(method_name)
          return true if concerns.private_class_method_defined?(method_name)
        end

        false
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
        commit_config!

        return super unless Utils::Module.class_method_defined?(self, method, private: true)

        return super if middlewares(method, scope: :class).defined_without_super_method?

        ConvenientService.logger.debug { "[Core] Included concerns into `#{self}` | Triggered by `method_missing` | Method: `.#{method}`" }

        __send__(method, *args, **kwargs, &block)
      end
    end
  end
end
