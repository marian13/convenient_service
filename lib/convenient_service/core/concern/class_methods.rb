# frozen_string_literal: true

module ConvenientService
  module Core
    module Concern
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
        # @return [Boolean] Returns `true` when config is committed, otherwise - `false`.
        #
        def has_committed_config?
          (@__convenient_service_config__ ||= Entities::Config.new(klass: self)).committed?
        end

        ##
        # Commits config when called for the first time.
        # Does nothing for the subsequent calls.
        #
        # @param trigger [ConvenientService::Support::UniqueValue]
        # @return [Boolean] `true` if called for the first time, `false` otherwise (similarly as `Kernel#require`).
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
        # @internal
        #   TODO: Create `def uncommit_config` that raises an explanatory exception why the "uncommitment" is NOT possible (because Ruby can NOT "uninclude" modules).
        ##

        ##
        # @param args [Array<Object>]
        # @param kwargs [Hash{Symbol => Object}]
        # @param block [Proc, nil]
        # @return [Object] Can be any type.
        #
        def new(*args, **kwargs, &block)
          has_committed_config? ? super : method_missing(:new, *args, **kwargs, &block)
        end

        private

        ##
        # @see https://thoughtbot.com/blog/always-define-respond-to-missing-when-overriding
        # @see https://blog.marc-andre.ca/2010/11/15/methodmissing-politely
        # @see https://stackoverflow.com/a/3304683/12201472
        #
        # @param method_name [Symbol, String]
        # @param include_private [Boolean]
        # @return [Boolean]
        #
        # @internal
        #   IMPORTANT: `respond_to_missing?` is like `initialize`. It is always `private`.
        #   - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
        #   - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
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

        ##
        # Commits config. In other words, includes `concerns` into the mixing class.
        # If `method` is still NOT defined, raises `NoMethodError`, otherwise - retries to call the `method`.
        #
        # @param method [Symbol]
        # @param args [Array<Object>]
        # @param kwargs [Hash{Symbol => Object}]
        # @param block [Proc, nil]
        # @return [void]
        #
        # @note Config commitment via a missing class method is very common. Convenient Service Standard config does that by `.new`, `.result` and `.step` most of the time.
        #
        # @internal
        #   IMPORTANT: `method_missing` MUST be thread-safe.
        #
        #   NOTE: `__send__` is used instead of `Support::SafeMethod` intentionally, since checking whether a method is defined is performed earlier by `Utils::Module.class_method_defined?`.
        #
        #   TODO: Include `method` into trigger metadata.
        #
        #   IMPORTANT: Ruby 2.7 and Ruby 3.0+ invoke this `method_missing` differently, check the following files/links:
        #   - `lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_callers.rb`
        #   - https://gist.github.com/marian13/9c25041f835564e945d978839097d419
        #
        #   IMPORTANT: Psych has a monkey-patch `y` in IRB. That is why calling `Service.y` raise `private method called` instead of `undefined method`.
        #   - https://github.com/ruby/psych/blob/v5.1.2/lib/psych/y.rb#L5
        #
        def method_missing(method, *args, **kwargs, &block)
          commit_config!(trigger: Constants::Triggers::CLASS_METHOD_MISSING)

          return ::ConvenientService.reraise { super } unless Utils::Module.class_method_defined?(self, method, public: true, protected: false, private: false)

          return ::ConvenientService.reraise { super } if middlewares(method, scope: :class).defined_without_super_method?

          ConvenientService.logger.debug { "[Core] Committed config for `#{self}` | Triggered by `method_missing` | Method: `.#{method}`" }

          __send__(method, *args, **kwargs, &block)
        end
      end
    end
  end
end
