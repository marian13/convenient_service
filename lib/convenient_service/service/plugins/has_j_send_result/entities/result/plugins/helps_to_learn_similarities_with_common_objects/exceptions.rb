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
              module HelpsToLearnSimilaritiesWithCommonObjects
                module Exceptions
                  class ErrorHasNoOtherTypeRepresentation < ::ConvenientService::Exception
                    ##
                    # @return [void]
                    #
                    def initialize_with_kwargs(type:)
                      message = <<~TEXT
                        Error results have no `#{type}` representation.

                        They are semantically similar to exceptions.
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
