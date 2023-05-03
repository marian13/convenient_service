# frozen_string_literal: true

require_relative "config/commands"
require_relative "config/entities"
require_relative "config/errors"

module ConvenientService
  module Core
    module Entities
      class Config
        ##
        # @!attribute [r] klass
        #   @return [Class]
        #
        attr_reader :klass

        ##
        # @param klass [Class]
        # @return [void]
        #
        def initialize(klass:)
          @klass = klass
        end

        ##
        # Sets or gets concerns for a service class.
        #
        # @overload concerns
        #   Returns all concerns.
        #   @return [ConvenientService::Core::Entities::Config::Entities::Concerns]
        #
        # @overload concerns(&configuration_block)
        #   Configures concerns.
        #   @param configuration_block [Proc] Block that configures middlewares.
        #   @see https://github.com/marian13/ruby-middleware#a-basic-example
        #   @return [ConvenientService::Core::Entities::Config::Entities::Concerns]
        #
        # @example Getter
        #   concerns
        #
        # @example Setter
        #   concerns(&configuration_block)
        #
        def concerns(&configuration_block)
          if configuration_block
            assert_not_committed!

            @concerns ||= Entities::Concerns.new(klass: klass)
            @concerns.configure(&configuration_block)
          end

          @concerns || Entities::Concerns.new(klass: klass)
        end

        ##
        # Sets or gets middlewares for a service class.
        #
        # @overload middlewares(method)
        #   Returns all instance middlewares for particular method.
        #   @param method [Symbol] Method name.
        #   @return [Hash{Symbol => Hash{Symbol => ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares}}]
        #
        # @overload middlewares(method, scope:)
        #   Returns all scoped middlewares for particular method.
        #   @param method [Symbol] Method name.
        #   @param scope [:instance, :class]
        #   @return [Hash{Symbol => Hash{Symbol => ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares}}]
        #
        # @overload middlewares(method, &configuration_block)
        #   Configures instance middlewares for particular method.
        #   @param method [Symbol] Method name.
        #   @param configuration_block [Proc] Block that configures middlewares.
        #   @see https://github.com/marian13/ruby-middleware#a-basic-example
        #   @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares]
        #
        # @overload middlewares(method, scope:, &configuration_block)
        #   Configures scoped middlewares for particular method.
        #   @param method [Symbol] Method name.
        #   @param scope [:instance, :class]
        #   @param configuration_block [Proc] Block that configures middlewares.
        #   @see https://github.com/marian13/ruby-middleware#a-basic-example
        #   @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares]
        #
        # @example Getters
        #   middlewares(:result)
        #   middlewares(:result, scope: :instance)
        #   middlewares(:result, scope: :class)
        #
        # @example Setters
        #   middlewares(:result, &configuration_block)
        #   middlewares(:result, scope: :instance, &configuration_block)
        #   middlewares(:result, scope: :class, &configuration_block)
        #
        def middlewares(method, scope: :instance, &configuration_block)
          @middlewares ||= {}
          @middlewares[scope] ||= {}

          if configuration_block
            assert_not_committed!

            @middlewares[scope][method] ||= Entities::MethodMiddlewares.new(scope: scope, method: method, klass: klass)
            @middlewares[scope][method].configure(&configuration_block)
            @middlewares[scope][method].define!
          end

          @middlewares[scope][method] || Entities::MethodMiddlewares.new(scope: scope, method: method, klass: klass)
        end

        ##
        # @return [ConvenientService::Support::ThreadSafeCounter]
        #
        def method_missing_commits_counter
          @method_missing_commits_counter ||= Support::ThreadSafeCounter.new(max_value: Constants::Commits::METHOD_MISSING_MAX_TRIES)
        end

        ##
        # @return [Boolean]
        #
        # @internal
        #   IMPORTANT:
        #     - Memoization of only `true` is intentional.
        #     - It is done for performance purposes.
        #     - It is OK to memoize only `true` since "uncommitment" of config is even theoretically NOT possible.
        #     - It is NOT possible to uninclude Ruby modules.
        #     - See `benchmark/has_committed_config/ips.rb`.
        #
        #   IMPORTANT: `committed?` MUST be thread safe.
        #
        def committed?
          @committed ||= concerns.included?
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
        def commit!(trigger: Constants::Triggers::USER)
          concerns.include!
            .tap { Commands::TrackMethodMissingCommitTrigger.call(config: self, trigger: trigger) }
        end

        private

        ##
        # @note: Config is committed either by `commit_config` or `method_missing` from `ConvenientService::Core::InstanceMethods` and `ConvenientService::Core::ClassMethods`.
        #
        # @return [void]
        # @raise [ConvenientService::Core::Entities::Config::Errors::ConfigIsCommitted]
        #
        # @internal
        #   NOTE: Concerns must be included only once since Ruby does NOT allow to modify the order of modules in the inheritance chain.
        #   TODO: Redesign core to have an ability to change order of included/extended modules in v3? Does it really worth it?
        #
        def assert_not_committed!
          return unless committed?

          raise Errors::ConfigIsCommitted.new(config: self)
        end
      end
    end
  end
end
