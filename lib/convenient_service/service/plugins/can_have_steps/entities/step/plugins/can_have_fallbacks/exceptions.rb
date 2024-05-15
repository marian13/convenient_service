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
                    def initialize_with_kwargs(step:, service:, status:)
                      message = <<~TEXT
                        Neither `fallback_#{status}_result` nor `fallback_result` methods of `#{service.class}` are overridden, but the step is marked to be fallbacked.

                        Either override one of those methods or remove the `fallback` option from the corresponding step definition in `#{step.container.klass}`.
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
