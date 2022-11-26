# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasInspect
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [String]
                    # @since 0.2.0
                    #
                    def inspect
                      "<#{service.class.name}::Result status: :#{status}>"
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
