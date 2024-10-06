# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasAmazingPrintInspect
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
                          service: Utils::Class.display_name(service.class),
                          status: status.to_sym
                        }
                      }

                      metadata[:ConvenientService][:data_keys] = unsafe_data.keys if unsafe_data.keys.any?
                      metadata[:ConvenientService][:message] = unsafe_message.to_s unless unsafe_message.empty?

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
