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
      #   middlewares(for: :result)
      #   middlewares(for: :result, scope: :instance)
      #   middlewares(for: :result, scope: :class)
      #
      #   # Setters:
      #   middlewares(for: :result, &block)
      #   middlewares(for: :result, scope: :instance, &block)
      #   middlewares(for: :result, scope: :class, &block)
      #
      def middlewares(**kwargs, &block)
        ##
        # TODO: Consider `Utils::Hash.rename_key(old_key, new_key, hash)`?
        # https://stackoverflow.com/a/19298437/12201472
        #
        kwargs[:method] = kwargs.delete(:for)
        kwargs[:scope] ||= :instance
        kwargs[:container] = self

        (@middlewares ||= {})
          .fetch(kwargs[:scope]) { @middlewares[kwargs[:scope]] = {} }
          .tap { |stacks| return stacks unless kwargs[:method] }
          .fetch(kwargs[:method]) { @middlewares[kwargs[:scope]][kwargs[:method]] = Entities::Middlewares::MiddlewareStack.new(**kwargs) }
          .tap { |stack| return stack unless block }
          .tap { |stack| stack.instance_exec(&block) } # TODO: configure(&block)
          .tap { |stack| Commands::EnableMethodMiddlewareStack.call(stack: stack) }
      end

      def commit_config!
        concerns.include!

        ConvenientService.logger.debug { "[Core] Included concerns into `#{self}` | Triggered by `.commit_config!`" }

        middlewares(scope: :instance).values.each { |stack| Commands::EnableMethodMiddlewareStack.call(stack: stack) }
        middlewares(scope: :class).values.each { |stack| Commands::EnableMethodMiddlewareStack.call(stack: stack) }
      end

      private

      def method_missing(method, *args, **kwargs, &block)
        concerns.include!

        ##
        # NOTE: If concerns are just included into the mixing class then retries the missing method,
        # otherwise raises `NoMethodError` (since method is still missing even after including concerns).
        #
        return super unless concerns.just_included?

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
