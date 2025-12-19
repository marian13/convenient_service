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
              module CanBeCalled
                module Exceptions
                  class ErrorResultIsCalled < ::ConvenientService::Exception
                    ##
                    # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @return [void]
                    #
                    def initialize_with_kwargs(result:)
                      message = <<~TEXT
                        An `error` result of service `#{Utils::Class.display_name(result.service.class)}` is called.

                        Only the `success` and `failure` results are expected to be called.

                        If this `error` result is expected:
                        1. Consider to use the `result` method instead of `call` (ensure the `:fault_tolerance` config option is enabled) - preferred.
                        2. Consider to use `begin/rescue ConvenientService::Result::Exceptions::ErrorResultIsCalled`.

                        If this `error` result is NOT expected, update the service logic.

                        Original `error` result message:
                        #{Utils::String.tab(result.unsafe_message)}
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
