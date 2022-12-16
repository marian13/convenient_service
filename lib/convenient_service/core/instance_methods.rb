# frozen_string_literal: true

module ConvenientService
  module Core
    module InstanceMethods
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
        return true if self.class.concerns.instance_method_defined?(method_name)

        if include_private
          return true if self.class.private_method_defined?(method_name)
          return true if self.class.concerns.private_instance_method_defined?(method_name)
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
        self.class.commit_config!(trigger: Constants::Triggers::INSTANCE_METHOD_MISSING)

        return super unless Utils::Module.instance_method_defined?(self.class, method, private: true)

        return super if self.class.middlewares(method, scope: :instance).defined_without_super_method?

        ConvenientService.logger.debug { "[Core] Committed config for `#{self.class}` | Triggered by `method_missing` | Method: `##{method}`" }

        __send__(method, *args, **kwargs, &block)
      end
    end
  end
end
