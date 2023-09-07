# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveFallback
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # Returns `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result` when overridden.
            #
            # @raise [ConvenientService::Service::Plugins::CanHaveFallback::Exceptions::FallbackResultIsNotOverridden]
            #
            def fallback_failure_result
              raise Exceptions::FallbackResultIsNotOverridden.new(service: self, status: :failure)
            end

            ##
            # Returns `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result` when overridden.
            #
            # @raise [ConvenientService::Service::Plugins::CanHaveFallback::Exceptions::FallbackResultIsNotOverridden]
            #
            def fallback_error_result
              raise Exceptions::FallbackResultIsNotOverridden.new(service: self, status: :error)
            end
          end

          class_methods do
            ##
            # Returns `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result` when `#fallback_result` is overridden.
            #
            # @raise [ConvenientService::Service::Plugins::CanHaveFallback::Exceptions::FallbackResultIsNotOverridden]
            #
            def fallback_failure_result(...)
              new(...).fallback_failure_result
            end

            ##
            # Returns `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result` when `#fallback_result` is overridden.
            #
            # @raise [ConvenientService::Service::Plugins::CanHaveFallback::Exceptions::FallbackResultIsNotOverridden]
            #
            # @example `fallback_error_result` method MUST always return `success` with reasonable "null" data.
            #
            #   For example, check the following service:
            #
            #     class SelectActiveUsers
            #       include ConvenientService::Standard::Config
            #
            #       # ...
            #
            #       def result
            #         # ...
            #
            #         success(users: ::User.where(active: true))
            #       end
            #
            #       # ...
            #     end
            #
            #   Since `result` returns relation for `users` when it is successful, its corresponding `fallback_error_result` must also return a relation.
            #
            #     class SelectActiveUsers
            #       include ConvenientService::Standard::Config
            #
            #       # ...
            #
            #       def fallback_error_result
            #         # ...
            #
            #         success(users: ::User.none)
            #       end
            #
            #       # ...
            #     end
            #
            #   This way a significant amount of extra `if` statements can be avoided.
            #
            #   result = SelectActiveUsers.result # or `result = SelectActiveUsers.fallback_error_result`
            #
            #   if result.success?
            #     result.data[:users].count
            #   end
            #
            #   It is safe to invoke `count` for both `result` and `fallback_error_result` since `result.data[:users]` return same class.
            #
            #   This idea can be applied in a broader sense by utilizing the Null object pattern.
            #
            # @see https://thoughtbot.com/blog/rails-refactoring-example-introduce-null-object
            # @see https://en.wikipedia.org/wiki/Null_object_pattern
            #
            # @internal
            #   TODO: Is it necessary to use `SetsParentToForeignResult` for `fallback_error_result`?
            #
            def fallback_error_result(...)
              new(...).fallback_error_result
            end
          end
        end
      end
    end
  end
end
