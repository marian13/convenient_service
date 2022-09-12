# frozen_string_literal: true

module ConvenientService
  module Configs
    module StandardUncommitted
      include Support::Concern

      ##
      # IMPORTANT: Order of plugins matters.
      #
      # NOTE: `class_exec' (that is used under the hood by `included') defines `class Result' in the global namespace.
      # That is why `class self::Result' is used.
      #
      # https://stackoverflow.com/a/51965126/12201472
      #
      # rubocop:disable Lint/ConstantDefinitionInBlock
      included do
        include Core

        concerns do
          use Plugins::Common::HasInternals::Concern
          use Plugins::Common::HasConstructor::Concern

          use Plugins::Common::CachesConstructorParams::Concern
          use Plugins::Common::CanBeCopied::Concern
          use Plugins::Service::HasResult::Concern
          use Plugins::Service::HasResultShortSyntax::Concern
          use Plugins::Service::HasResultSteps::Concern
          use Plugins::Service::CanRecalculateResult::Concern

          use Plugins::Common::HasCallbacks::Concern
          use Plugins::Common::HasAroundCallbacks::Concern

          ##
          # NOTE: Optional plugins.
          # TODO: Specs.
          #
          #   use Plugins::Common::HasConfig::Concern
          #
        end

        middlewares for: :initialize do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Common::CachesConstructorParams::Middleware
        end

        middlewares for: :result do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Service::HasResult::Middleware

          use Plugins::Service::HasResultSteps::Middleware

          use Plugins::Common::HasCallbacks::Middleware
          use Plugins::Common::HasAroundCallbacks::Middleware

          use Plugins::Service::RaisesOnDoubleResult::Middleware

          use Plugins::Common::CachesReturnValue::Middleware
        end

        middlewares for: :success do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Service::HasResultShortSyntax::Success::Middleware
        end

        middlewares for: :failure do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Service::HasResultShortSyntax::Failure::Middleware
        end

        middlewares for: :error do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Service::HasResultShortSyntax::Error::Middleware
        end

        middlewares for: :step, scope: :class do
          use Plugins::Common::NormalizesEnv::Middleware

          use Plugins::Service::HasResultMethodSteps::Middleware
        end

        class self::Internals
          include Core

          concerns do
            use Plugins::Internals::HasCache::Concern
          end
        end

        class self::Result
          include Core

          concerns do
            use Plugins::Common::HasInternals::Concern

            use Plugins::Result::HasResultShortSyntax::Concern
            use Plugins::Result::CanRecalculateResult::Concern
          end

          middlewares for: :success? do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares for: :failure? do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares for: :error? do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares for: :not_success? do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares for: :not_failure? do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares for: :not_error? do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::MarksResultStatusAsChecked::Middleware
          end

          middlewares for: :data do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
          end

          middlewares for: :message do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
          end

          middlewares for: :code do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware
          end

          class self::Internals
            include Core

            concerns do
              use Plugins::Internals::HasCache::Concern
            end
          end
        end

        class self::Step
          include Core

          concerns do
            use Plugins::Common::HasInternals::Concern
          end

          middlewares for: :result do
            use Plugins::Common::NormalizesEnv::Middleware

            use Plugins::Common::CachesReturnValue::Middleware
          end

          class self::Internals
            include Core

            concerns do
              use Plugins::Internals::HasCache::Concern
            end
          end
        end
      end
      # rubocop:enable Lint/ConstantDefinitionInBlock
    end
  end
end

module ConvenientService
  module Configs
    ##
    # NOTE: A copy of `StandardUncommitted' config, that automatically commits itself after the `include' invocation.
    #
    # For example:
    #
    #   class PerformOperation
    #     include ConvenientService::Configs::StandardCommitted
    #     # ...
    #   end
    #
    # is roughly equivalent to:
    #
    #   class PerformOperation
    #     include ConvenientService::Configs::StandardUncommitted
    #
    #     commit_config!
    #     # ...
    #   end
    #
    StandardCommitted = StandardUncommitted.dup.tap do |mod|
      mod.module_exec do
        def self.included(klass)
          klass.commit_config!
        end
      end
    end
  end
end

module ConvenientService
  module Configs
    ##
    # IMPORTANT: Breaking change!!!
    # Automatic config commitment by `method_missing' does NOT work in Ruby 2.7.
    # That is probably caused by `(*args, **kwargs, &block)' delegation.
    # Check the following article for more information: https://eregon.me/blog/2021/02/13/correct-delegation-in-ruby-2-27-3.html
    # As a workaround, the `Standard' config is committed by default in Ruby 2.7.
    # Ruby 3.0 and higher use `StandardUncommitted' as `Standard' since they have no issues with `(*args, **kwargs, &block)' delegation.
    #
    # For migration purposes, you can control config commitment, by using `StandardUncommitted' and `StandardCommitted' explicitly, for example:
    #
    #   class PerformOperation
    #     include ConvenientService::Configs::Standard
    #     # ...
    #   end
    #
    # is equivalent to the following in Ruby 2.7
    #
    #   class PerformOperation
    #     include ConvenientService::Configs::StandardCommitted
    #     # ...
    #   end
    #
    # and in Ruby 3.0+
    #
    #   class PerformOperation
    #     include ConvenientService::Configs::StandardUncommitted
    #     # ...
    #     # Trigger `commit_config!` manually or it is automatically triggered by first `method_missing'.
    #   end
    #
    Standard = ::RUBY_VERSION >= "3.0" ? StandardUncommitted : StandardCommitted
  end
end
