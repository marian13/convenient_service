# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
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
                          status: status.to_s,
                          service: service.class.name
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
