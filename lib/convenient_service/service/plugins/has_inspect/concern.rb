# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasInspect
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [String]
            #
            def inspect
              "<#{Utils::Class.display_name(self.class)}>"
            end
          end
        end
      end
    end
  end
end
