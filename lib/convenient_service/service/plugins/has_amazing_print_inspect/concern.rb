# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
