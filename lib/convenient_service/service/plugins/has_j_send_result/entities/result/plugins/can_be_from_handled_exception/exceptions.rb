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
              module CanBeFromHandledException
                module Exceptions
                  class FromExceptionOnNotErrorResult < ::ConvenientService::Exception
                    ##
                    # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @return [void]
                    #
                    def initialize_with_kwargs(result:)
                      message = <<~TEXT
                        `#{result.status}(...).from_exception(exception, ...)` is NOT allowed. Only `error` results can be from exceptions.
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
