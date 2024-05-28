# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanHaveFallbacks
                module Exceptions
                  class FallbackResultIsNotOverridden < ::ConvenientService::Exception
                    ##
                    # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                    # @param service [ConvenientService::Service]
                    # @param status [Symbol]
                    # @return [void]
                    #
                    def initialize_with_kwargs(step:, service:, status:)
                      message = <<~TEXT
                        Neither `fallback_#{status}_result` nor `fallback_result` methods of `#{service.class}` are overridden, but the step is marked to be fallbacked.

                        Either override one of those methods or remove the `fallback` option from the corresponding step definition in `#{step.container.klass}`.
                      TEXT

                      initialize(message)
                    end
                  end

                  class MethodStepCanNotHaveFallback < ::ConvenientService::Exception
                    ##
                    # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                    # @return [void]
                    #
                    def initialize_with_kwargs(step:)
                      message = <<~TEXT
                        Method step can NOT have fallback.

                        Either remove `fallback` option from step `:#{step.method}` in `#{step.container.klass}` or consider to refactor it into a service step.
                      TEXT

                      initialize(message)
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
