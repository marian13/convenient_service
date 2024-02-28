# frozen_string_literal: true

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
