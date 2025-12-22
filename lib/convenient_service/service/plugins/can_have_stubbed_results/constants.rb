# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResults
        module Constants
          module Triggers
            ##
            # @return [ConvenientService::Support::UniqueValue]
            #
            STUB_SERVICE = Support::UniqueValue.new("STUB_SERVICE")
          end
        end
      end
    end
  end
end
