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
        concerns.include!

        ##
        # NOTE: If concerns are just included into the mixing class then retries the missing method,
        # otherwise raises `NoMethodError` (since method is still missing even after including concerns).
        #
        # TODO: Logger spec.
        #
        return super unless concerns.just_included?

        ConvenientService.logger.debug { "[Core] Included concerns into `#{self.class}` | Triggered by `method_missing` | Method: `##{method}` " }

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
