# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasAwesomePrintInspect
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [String]
                    #
                    def inspect
                      metadata = {
                        ConvenientService: {
                          entity: "Result",
                          service: service.inspect_values[:name],
                          status: status.to_sym
                        }
                      }

                      metadata.ai
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
