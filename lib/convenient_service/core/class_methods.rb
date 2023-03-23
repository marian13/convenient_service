# frozen_string_literal: true

module ConvenientService
  module Core
    module ClassMethods
      ##
      # @see ConvenientService::Core::Entities::Config#concerns
      #
      # @internal
      #   NOTE: The instance variable is named `@__convenient_service_config__` intentionally in order to decrease the possibility of accidental redefinition by the end-user.
      #   NOTE: An `attr_reader` for `@__convenient_service_config__` is NOT created intentionally in order to NOT pollute the end-user class interface.
      #
      def concerns(...)
        (@__convenient_service_config__ ||= Entities::Config.new(klass: self)).concerns(...)
      end

      ##
      # @see ConvenientService::Core::Entities::Config#middlewares
      #
      # @internal
      #   NOTE: The instance variable is named `@__convenient_service_config__` intentionally in order to decrease the possibility of accidental redefinition by the end-user.
      #   NOTE: An `attr_reader` for `@__convenient_service_config__` is NOT created intentionally in order to NOT pollute the end-user class interface.
      #
      def middlewares(...)
        (@__convenient_service_config__ ||= Entities::Config.new(klass: self)).middlewares(...)
      end

      ##
      # Commits config when called for the first time.
      # Does nothing for the subsequent calls.
      #
      # @param trigger [ConvenientService::Support::UniqueValue]
      # @return [Boolean] true if called for the first time, false otherwise (similarly as Kernel#require).
      #
      # @see https://ruby-doc.org/core-3.1.2/Kernel.html#method-i-require
      #
      # @internal
      #   NOTE: The instance variable is named `@__convenient_service_config__` intentionally in order to decrease the possibility of accidental redefinition by the end-user.
      #   NOTE: An `attr_reader` for `@__convenient_service_config__` is NOT created intentionally in order to NOT pollute the end-user class interface.
      #
      def commit_config!(trigger: ConvenientService::Core::Constants::Triggers::USER)
        (@__convenient_service_config__ ||= Entities::Config.new(klass: self)).commit!(trigger: trigger)
          .tap { ConvenientService.logger.debug { "[Core] Committed config for `#{self}` | Triggered by `.commit_config!(trigger: #{trigger.inspect})` " } }
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
      #   IMPORTANT: `method_missing` MUST be thread-safe.
      #
      #   NOTE: `__send__` is used instead of `Support::SafeMethod` intentionally, since checking whether a method is defined is performed earlier by `Utils::Module.class_method_defined?`.
      #
      def method_missing(method, *args, **kwargs, &block)
        commit_config!(trigger: Constants::Triggers::CLASS_METHOD_MISSING)

        return super unless Utils::Module.class_method_defined?(self, method, private: true)

        return super if middlewares(method, scope: :class).defined_without_super_method?

        ConvenientService.logger.debug { "[Core] Committed config for `#{self}` | Triggered by `method_missing` | Method: `.#{method}`" }

        __send__(method, *args, **kwargs, &block)
      end
    end
  end
end
