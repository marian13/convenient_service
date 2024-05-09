# frozen_string_literal: true

module ConvenientService
  module Service
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
                  entity: "Service",
                  name: inspect_values[:name]
                }
              }

              metadata.ai
            end

            ##
            # @return [Hash{Symbol => Object}]
            #
            # @internal
            #   NOTE: It is a coincidence that `HasInspect#inspect_values` has exactly the same implementation. There is NO intention to keep them in sync.
            #
            def inspect_values
              {name: Utils::Class.display_name(self.class)}
            end
          end
        end
      end
    end
  end
end
