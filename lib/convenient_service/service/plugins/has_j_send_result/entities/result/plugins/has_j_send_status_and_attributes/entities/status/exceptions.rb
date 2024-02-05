# frozen_string_literal: true

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
                    module Exceptions
                      class ErrorHasNoBooleanRepresentation < ::ConvenientService::Exception
                        ##
                        # @return [void]
                        #
                        def initialize_without_arguments
                          message = <<~TEXT
                            Error results have no boolean representation.

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
  end
end
