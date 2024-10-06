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
                  name: Utils::Class.display_name(self.class)
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
