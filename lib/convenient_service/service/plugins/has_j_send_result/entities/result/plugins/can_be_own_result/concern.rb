# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module CanBeOwnResult
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # Checks whether a result is an own result for a service instance.
                    # If the result is own then it is one of `success`, `failure`, `error` or step result.
                    # Otherwise it is foreign for that particular service instance.
                    #
                    # @api private
                    #
                    # @param service [ConvenientService::Service]
                    # @return [Boolean]
                    #
                    # @example `success`, `failure` and `error` are own results for service instance.
                    #   class Service
                    #     include ConvenientService::Standard::Config
                    #
                    #     def result
                    #       success
                    #     end
                    #   end
                    #
                    #   first_service = Service.new
                    #   second_service = Service.new
                    #
                    #   first_service.result.own_result_for?(first_service)
                    #   # => true
                    #
                    #   second_service.result.own_result_for?(first_service)
                    #   # => false
                    #
                    # @example Service step results are own results for service instance.
                    #   class Service
                    #     include ConvenientService::Standard::Config
                    #
                    #     step OtherService
                    #   end
                    #
                    #   first_service = Service.new
                    #   second_service = Service.new
                    #
                    #   first_service.steps.first.result.own_result_for?(first_service)
                    #   # => true
                    #
                    #   second_service.steps.first.result.own_result_for?(first_service)
                    #   # => false
                    #
                    # @example Method step results are own results for service instance.
                    #   class Service
                    #     include ConvenientService::Standard::Config
                    #
                    #     step :foo
                    #
                    #     def foo
                    #       success
                    #     end
                    #   end
                    #
                    #   first_service = Service.new
                    #   second_service = Service.new
                    #
                    #   first_service.steps.first.result.own_result_for?(first_service)
                    #   # => true
                    #
                    #   second_service.steps.first.result.own_result_for?(first_service)
                    #   # => false
                    #
                    # @example All results that are NOT any of `success`, `failure`, `error` or step results are NOT own results for service instance. Such results are called `foreign` service results.
                    #   class Service
                    #     include ConvenientService::Standard::Config
                    #
                    #     def result
                    #       OtherService.result
                    #     end
                    #   end
                    #
                    #   first_service = Service.new
                    #   second_service = Service.new
                    #
                    #   first_service.result.own_result_for?(first_service)
                    #   # => false
                    #
                    #   second_service.result.own_result_for?(first_service)
                    #   # => false
                    #
                    # @example Edge case: Step results are always own even when method step result calls foreign service result.
                    #   class Service
                    #     include ConvenientService::Standard::Config
                    #
                    #     step :foo
                    #
                    #     def foo
                    #       OtherService.result
                    #     end
                    #   end
                    #
                    #   first_service = Service.new
                    #   second_service = Service.new
                    #
                    #   first_service.result.own_result_for?(first_service)
                    #   # => true
                    #
                    #   second_service.result.own_result_for?(first_service)
                    #   # => false
                    #
                    def own_result_for?(service)
                      self.service.equal?(service)
                    end

                    ##
                    # Checks whether a result is a foreign result for a service instance.
                    # Opposite to own result.
                    #
                    # @api private
                    #
                    # @param service [ConvenientService::Service]
                    # @return [Boolean]
                    #
                    def foreign_result_for?(service)
                      !own_result_for?(service)
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
