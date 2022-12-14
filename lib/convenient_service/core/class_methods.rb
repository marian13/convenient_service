# frozen_string_literal: true

module ConvenientService
  module Core
    module ClassMethods
      ##
      # @see ConvenientService::Core::Entities::Config#concerns
      #
      def concerns(...)
        (@__config__ ||= Entities::Config.new(klass: self)).concerns(...)
      end

      ##
      # @see ConvenientService::Core::Entities::Config#middlewares
      #
      def middlewares(...)
        (@__config__ ||= Entities::Config.new(klass: self)).middlewares(...)
      end

      ##
      # Commits config when called for the first time.
      # Does nothing for the subsequent calls.
      #
      # @return [Boolean] true if called for the first time, false otherwise (similarly as Kernel#require).
      #
      # @see https://ruby-doc.org/core-3.1.2/Kernel.html#method-i-require
      #
      def commit_config!
        (@__config__ ||= Entities::Config.new(klass: self)).commit!
          .tap { ConvenientService.logger.debug { "[Core] Committed config for `#{self}` | Triggered by `.commit_config!`" } }
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

        ConvenientService.logger.debug { "[Core] Committed config for `#{self}` | Triggered by `method_missing` | Method: `.#{method}`" }

        __send__(method, *args, **kwargs, &block)
      end
    end
  end
end
