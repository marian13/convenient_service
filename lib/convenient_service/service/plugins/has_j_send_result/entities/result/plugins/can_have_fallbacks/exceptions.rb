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
                module Exceptions
                  class FallbackResultIsNotOverridden < ::ConvenientService::Exception
                    ##
                    # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @param status [Symbol]
                    # @return [void]
                    #
                    def initialize_with_kwargs(result:, status:)
                      message = <<~TEXT
                        Result has NO `#{status}` fallback since neither `fallback_#{status}_result` nor `fallback_result` methods of `#{Utils::Class.display_name(result.service.class)}` are overridden.
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
