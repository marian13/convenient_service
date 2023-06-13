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
                  name: inspect_values[:name]
                }
              }

              metadata.ai
            end

            ##
            # @return [Hash{Symbol => Object}]
            #
            def inspect_values
              {name: self.class.name}
            end
          end
        end
      end
    end
  end
end
