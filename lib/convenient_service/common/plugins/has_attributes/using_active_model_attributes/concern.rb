# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module HasAttributes
        module UsingActiveModelAttributes
          module Concern
            include Support::Concern

            included do |service_class|
              service_class.include Patches::ActiveModelAttributes
            end
          end
        end
      end
    end
  end
end
