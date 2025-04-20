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
                  class Code
                    module Commands
                      ##
                      # Check whether `code` can be considered as `Code` instance.
                      #
                      class IsCode < Support::Command
                        ##
                        # @!attribute [r] code
                        #   @return [Object] Can be any type.
                        #
                        attr_reader :code

                        ##
                        # @param code [Object] Can be any type.
                        # @return [void]
                        #
                        def initialize(code:)
                          @code = code
                        end

                        ##
                        # @return [Boolean]
                        #
                        def call
                          code.class.include?(Entities::Code::Concern)
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
