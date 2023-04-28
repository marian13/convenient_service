# frozen_string_literal: true

module ConvenientService
  module Service
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
                  entity: "Service",
                  name: self.class.name
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
