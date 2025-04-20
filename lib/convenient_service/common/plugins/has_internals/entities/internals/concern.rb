# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module HasInternals
        module Entities
          class Internals
            module Concern
              include Support::Concern

              instance_methods do
                def ==(other)
                  return unless other.instance_of?(self.class)

                  true
                end
              end
            end
          end
        end
      end
    end
  end
end
