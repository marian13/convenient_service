# frozen_string_literal: true

module ConvenientService
  module Core
    module ClassMethods
      ##
      # @example Getter.
      #   concerns
      #
      # @example Setter.
      #   concerns(&configuration_block)
      #
      # @return [ConvenientService::Core::Entities::Concerns] concerns for self.
      #
      def concerns(&configuration_block)
        @concerns ||= Entities::Concerns.new(entity: self)

        return @concerns unless configuration_block

        @concerns.assert_not_included!

        @concerns.configure(&configuration_block)

        @concerns
      end

      ##
      # Usage example:
      #
      #   # Getters:
      #   middlewares
      #   middlewares(scope: :instance)
      #   middlewares(scope: :class)
      #   middlewares(for: :result)
      #   middlewares(for: :result, scope: :instance)
      #   middlewares(for: :result, scope: :class)
      #
      #   # Setters:
      #   middlewares(for: :result, &block)
      #   middlewares(for: :result, scope: :instance, &block)
      #   middlewares(for: :result, scope: :class, &block)
      #
      def middlewares(**kwargs, &configuration_block)
        scope = kwargs[:scope] || :instance
        method = kwargs[:for] || (raise ::ArgumentError if configuration_block)
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

      def commit_config!
        concerns.include!

        ConvenientService.logger.debug { "[Core] Included concerns into `#{self}` | Triggered by `.commit_config!`" }

        middlewares(scope: :instance).values.each(&:define!)
        middlewares(scope: :class).values.each(&:define!)
      end

      private

      def method_missing(method, *args, **kwargs, &block)
        concerns.include!

        ##
        # NOTE: If concerns are just included into the mixing class then retries the missing method,
        # otherwise raises `NoMethodError` (since method is still missing even after including concerns).
        #
        return super unless concerns.included_once?

        ConvenientService.logger.debug { "[Core] Included concerns into `#{self}` | Triggered by `method_missing` | Method: `.#{method}` " }

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
