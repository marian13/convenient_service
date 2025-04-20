# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module HasInstanceProxy
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @return [Class] Can be any type.
            #
            def instance_proxy_class
              @instance_proxy_class ||= Commands::CreateInstanceProxyClass[target_class: self]
            end
          end
        end
      end
    end
  end
end
