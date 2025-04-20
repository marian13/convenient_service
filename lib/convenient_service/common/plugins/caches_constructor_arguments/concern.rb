# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module CachesConstructorArguments
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [ConvenientService::Support::Arguments]
            #
            def constructor_arguments
              internals.cache[:constructor_arguments] || Support::Arguments.null_arguments
            end
          end
        end
      end
    end
  end
end
