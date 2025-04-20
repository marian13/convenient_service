# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module HasMemoization
        module UsingMemoWise
          module Concern
            include Support::Concern

            included do
              prepend ::MemoWise
            end
          end
        end
      end
    end
  end
end
