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
              module HasStubbedResultInvocationsCounter
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [ConvenientService::Support::ThreadSafeCounter]
                    #
                    def stubbed_result_invocations_counter
                      extra_kwargs[:stubbed_result_invocations_counter]
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
