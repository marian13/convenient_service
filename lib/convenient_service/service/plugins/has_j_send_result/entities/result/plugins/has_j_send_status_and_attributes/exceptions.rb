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
                module Exceptions
                  class NotExistingAttribute < ::ConvenientService::Exception
                    ##
                    # @param attribute [Symbol]
                    # @return [void]
                    #
                    def initialize_with_kwargs(attribute:)
                      message = <<~TEXT
                        Data attribute `#{attribute}` does NOT exist. Make sure the corresponding result returns it.
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
