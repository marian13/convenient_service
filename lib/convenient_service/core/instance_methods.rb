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
      def middlewares(*args, **kwargs, &block)
        self.class.middlewares(*args, **kwargs, &block)
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
        return true if concerns.instance_method_defined?(method_name)

        if include_private
          return true if self.class.private_method_defined?(method_name)
          return true if concerns.private_instance_method_defined?(method_name)
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
        concerns.include!

        return super unless Utils::Method.defined?(method, self.class, private: true)

        ConvenientService.logger.debug { "[Core] Included concerns into `#{self.class}` | Triggered by `method_missing` | Method: `##{method}`" }

        __send__(method, *args, **kwargs, &block)
      end
    end
  end
end
