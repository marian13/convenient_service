# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module CanHaveFallbacks
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden]
                    #
                    def with_fallback(...)
                      with_failure_fallback(...)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden]
                    #
                    def with_fallback_for(statuses_to_fallback, **kwargs)
                      case status.to_sym
                      when :success
                        self
                      when :failure
                        Utils::Array.wrap(statuses_to_fallback).include?(:failure) ? with_failure_fallback(**kwargs) : self
                      else # error
                        Utils::Array.wrap(statuses_to_fallback).include?(:error) ? with_error_fallback(**kwargs) : self
                      end
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden]
                    #
                    # @internal
                    #   TODO: Add a link to the original result? For example: `fallback.copy(original_result: result)`?
                    #
                    #   NOTE: The `__send__` and `has_own_instance_method?` combination is used to respect possible custom middlewares.
                    #   NOTE: No need for extra checks to allow `result.with_fallback.with_fallback` since fallbacks are always `success` results.
                    #
                    def with_failure_fallback(raise_when_missing: true)
                      return self unless status.unsafe_failure?

                      return service.__send__(:fallback_failure_result) if Utils::Module.has_own_instance_method?(service.class, :fallback_failure_result, private: true)
                      return service.__send__(:fallback_result) if Utils::Module.has_own_instance_method?(service.class, :fallback_result, private: true)

                      ::ConvenientService.raise Exceptions::FallbackResultIsNotOverridden.new(result: self, status: :failure) if raise_when_missing
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden]
                    #
                    # @internal
                    #   TODO: Add a link to the original result? For example: `fallback.copy(original_result: result)`?
                    #
                    #   NOTE: The `__send__` and `has_own_instance_method?` combination is used to respect possible custom middlewares.
                    #   NOTE: No need for extra checks to allow `result.with_fallback.with_fallback` since fallbacks are always `success` results.
                    #
                    def with_error_fallback(raise_when_missing: true)
                      return self unless status.unsafe_error?

                      return service.__send__(:fallback_error_result) if Utils::Module.has_own_instance_method?(service.class, :fallback_error_result, private: true)
                      return service.__send__(:fallback_result) if Utils::Module.has_own_instance_method?(service.class, :fallback_result, private: true)

                      ::ConvenientService.raise Exceptions::FallbackResultIsNotOverridden.new(result: self, status: :error) if raise_when_missing
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Exceptions::FallbackResultIsNotOverridden]
                    #
                    def with_failure_and_error_fallback(...)
                      case status.to_sym
                      when :success
                        self
                      when :failure
                        with_failure_fallback(...)
                      else # :error
                        with_error_fallback(...)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
