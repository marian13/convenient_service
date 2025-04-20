# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module HasConstructor
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [void]
            #
            def initialize(...)
            end
          end

          class_methods do
            ##
            # @return [Object] Can be any type.
            #
            def new(...)
              new_without_commit_config(...)
            end
          end
        end
      end
    end
  end
end
