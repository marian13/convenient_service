# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "config/commands"
require_relative "config/entities"
require_relative "config/exceptions"

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
        # @!attribute [r] lock
        #   @return [Mutex]
        #
        attr_reader :lock

        ##
        # @param klass [Class]
        # @return [void]
        #
        def initialize(klass:)
          @klass = klass

          ##
          # IMPORTANT: Intentionally initializes `lock` in constructor to ensure thread-safety.
          #
          @lock = ::Mutex.new
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
          @middlewares ||= Support::Cache.backed_by(:hash).new

          scoped_middlewares = @middlewares.scope(scope)
          method_middlewares = scoped_middlewares.get(method) || Entities::MethodMiddlewares.new(scope: scope, method: method, klass: klass)

          return method_middlewares unless configuration_block

          assert_not_committed!

          method_middlewares.configure(&configuration_block)

          if method_middlewares.any?
            method_middlewares.define!

            scoped_middlewares.set(method, method_middlewares)
          else
            method_middlewares.undefine!

            scoped_middlewares.delete(method)
          end

          method_middlewares
        end

        ##
        # This method is intended to be used only inside config `included` blocks.
        #
        # @return [ConvenientService::Config::Entities::OptionCollection]
        #
        # @internal
        #   NOTE: `namespace` is defined only for classes that were created by `Config#entity`.
        #
        def options
          @options ||= Utils.safe_send(klass, :namespace)&.__convenient_service_config__&.options || ConvenientService::Config.empty_options
        end

        ##
        # This method is intended to be used only inside config `included` blocks.
        #
        # @param name [Symbol]
        # @param configuration_block [Proc, nil]
        # @return [Class, nil]
        #
        def entity(name, &configuration_block)
          return Commands::FindEntityClass.call(config: self, name: name) unless configuration_block

          assert_not_committed!

          entity_class = Commands::FindOrCreateEntityClass.call(config: self, name: name)

          entity_class.class_exec(&configuration_block)

          entity_class
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
        # @internal
        #   IMPORTANT: `commit!` MUST be thread safe.
        #
        #   NOTE: Inspired by `Response#commit!` and others.
        #   - https://github.com/rails/rails/blob/36c1591bcb5e0ee3084759c7f42a706fe5bb7ca7/actionpack/lib/action_controller/metal/live.rb#L307
        #
        def commit!(trigger: Constants::Triggers::USER)
          (committed? ? false : concerns.include!)
            .tap { Commands::TrackMethodMissingCommitTrigger.call(config: self, trigger: trigger) }
        end

        private

        ##
        # @note Config is committed either by `commit_config` or `method_missing` from `ConvenientService::Core::InstanceMethods` and `ConvenientService::Core::ClassMethods`.
        #
        # @return [void]
        # @raise [ConvenientService::Core::Entities::Config::Exceptions::ConfigIsCommitted]
        #
        # @internal
        #   NOTE: Concerns must be included only once since Ruby does NOT allow to modify the order of modules in the inheritance chain.
        #   TODO: Redesign core to have an ability to change order of included/extended modules in v3? Does it really worth it?
        #
        def assert_not_committed!
          return unless committed?

          ::ConvenientService.raise Exceptions::ConfigIsCommitted.new(config: self)
        end
      end
    end
  end
end
