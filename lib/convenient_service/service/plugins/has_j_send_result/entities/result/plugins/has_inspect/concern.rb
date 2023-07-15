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
                      "<#{service.inspect_values[:name]}::Result status: :#{status}>"
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
