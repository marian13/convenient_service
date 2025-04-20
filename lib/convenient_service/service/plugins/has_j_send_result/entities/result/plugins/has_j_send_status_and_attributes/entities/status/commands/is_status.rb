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
              module HasJSendStatusAndAttributes
                module Entities
                  class Status
                    module Commands
                      ##
                      # Check whether `status` can be considered as `Status` instance.
                      #
                      class IsStatus < Support::Command
                        ##
                        # @!attribute [r] status
                        #   @return [Object] Can be any type.
                        #
                        attr_reader :status

                        ##
                        # @param status [Object] Can be any type.
                        # @return [void]
                        #
                        def initialize(status:)
                          @status = status
                        end

                        ##
                        # @return [Boolean]
                        #
                        def call
                          status.class.include?(Entities::Status::Concern)
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
end
