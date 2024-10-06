# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasInspect
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [String]
                    #
                    def inspect
                      parts = [
                        "#{Utils::Class.display_name(service.class)}::Result status: :#{status}"
                      ]

                      parts << "data_keys: #{unsafe_data.keys.inspect}" if unsafe_data.keys.any?
                      parts << "message: \"#{unsafe_message}\"" unless unsafe_message.empty?

                      "<#{parts.join(", ")}>"
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
