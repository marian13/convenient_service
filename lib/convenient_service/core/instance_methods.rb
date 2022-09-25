# frozen_string_literal: true

module ConvenientService
  module Core
    module InstanceMethods
      def concerns(&block)
        self.class.concerns(&block)
      end

      def middlewares(**kwargs, &block)
        self.class.middlewares(**kwargs, &block)
      end

      private

      def method_missing(method, *args, **kwargs, &block)
        just_enabled = Commands::EnableConcernMiddlewareStack.call(stack: concerns)

        ##
        # NOTE: If concerns are just enabled (are just included into the mixing class) then retries the missing method,
        # otherwise raises `NoMethodError' (since method is still missing even after including concerns).
        #
        # TODO: Logger spec.
        #
        return super unless just_enabled

        ConvenientService.logger.debug { "[Core] Enabled concern middleware stack for `#{self.class}' | Triggered by `method_missing' | Method: `##{method}' " }

        send(method, *args, **kwargs, &block)
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
