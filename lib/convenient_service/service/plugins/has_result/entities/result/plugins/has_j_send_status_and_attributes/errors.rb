# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Errors
                  class NotExistingAttribute < ::ConvenientService::Error
                    ##
                    # @param attribute [Symbol]
                    # @return [void]
                    #
                    def initialize(attribute:)
                      message = <<~TEXT
                        Data attribute `#{attribute}` does NOT exist. Make sure the corresponding result returns it.
                      TEXT

                      super(message)
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