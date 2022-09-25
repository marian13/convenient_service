# frozen_string_literal: true

module ConvenientService
  module Core
    module ClassMethods
      ##
      # Usage example:
      #
      #   # Getters:
      #   concerns
      #
      #   # Setters:
      #   concerns(&block)
      #
      def concerns(&block)
        (@concerns ||= Entities::Concerns::MiddlewareStack.new(entity: self))
          .tap { |stack| return stack unless block }
          .tap { |stack| Commands::AssertConcernMiddlewareStackNotFixed.call(stack: stack) }
          .tap { |stack| Commands::ConfigureMiddlewareStack.call(stack: stack, block: block) }
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
        # TODO: Consider `Utils::Hash.rename_key(old_key, new_key, hash)'?
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
          .tap { |stack| Commands::ConfigureMiddlewareStack.call(stack: stack, block: block) }
          .tap { |stack| Commands::EnableMethodMiddlewareStack.call(stack: stack) }
      end

      def commit_config!
        concerns.tap { |stack| Commands::EnableConcernMiddlewareStack.call(stack: stack) }

        ConvenientService.logger.debug { "[Core] Enabled concern middleware stack for `#{self}' | Triggered by `.commit_config!'" }

        middlewares(scope: :instance).values.each { |stack| Commands::EnableMethodMiddlewareStack.call(stack: stack) }
        middlewares(scope: :class).values.each { |stack| Commands::EnableMethodMiddlewareStack.call(stack: stack) }
      end

      private

      def method_missing(method, *args, **kwargs, &block)
        just_enabled = Commands::EnableConcernMiddlewareStack.call(stack: concerns)

        ##
        # NOTE: If concerns are just enabled (are just included into the mixing class) then retries the missing method,
        # otherwise raises `NoMethodError' (since method is still missing even after including concerns).
        #
        return super unless just_enabled

        ConvenientService.logger.debug { "[Core] Enabled concern middleware stack for `#{self}' | Triggered by `method_missing' | Method: `.#{method}' " }

        __send__(method, *args, **kwargs, &block)
      end

      ##
      # TODO: Implement.
      # https://thoughtbot.com/blog/always-define-respond-to-missing-when-overriding
      #
      def respond_to_missing?(method_name, include_private = false)
        false
      end
    end
  end
end
