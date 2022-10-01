# frozen_string_literal: true

module ConvenientService
  module Core
    module InstanceMethods
      ##
      # @param (see ConvenientService::Core::ClassMethods#concerns)
      # @return [ConvenientService::Core::Entities::Concerns]
      #
      def concerns(&configuration_block)
        self.class.concerns(&configuration_block)
      end

      ##
      # @param (see ConvenientService::Core::ClassMethods#middlewares)
      # @return [ConvenientService::Core::Entities::MethodMiddlewares]
      #
      def middlewares(**kwargs, &block)
        self.class.middlewares(**kwargs, &block)
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
        return true if self.class.method_defined?(method_name)
        return true if concerns.method_defined?(method_name)

        if include_private
          return true if self.class.private_method_defined?(method_name)
          return true if concerns.private_method_defined?(method_name)
        end

        false
      end

      private

      ##
      # @param method [Symbol]
      # @param args [Array]
      # @param kwargs [Hash]
      # @param block [Proc]
      # @return [void]
      #
      def method_missing(method, *args, **kwargs, &block)
        concerns.include!

        ##
        # NOTE: If concerns are just included into the mixing class then retries the missing method,
        # otherwise raises `NoMethodError` (since method is still missing even after including concerns).
        #
        # TODO: Logger spec.
        #
        return super unless concerns.included_once?

        ConvenientService.logger.debug { "[Core] Included concerns into `#{self.class}` | Triggered by `method_missing` | Method: `##{method}`" }

        __send__(method, *args, **kwargs, &block)
      end
    end
  end
end
