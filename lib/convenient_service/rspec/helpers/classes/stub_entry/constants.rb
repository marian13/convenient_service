# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        class StubEntry < Support::Command
          module Constants
            module Triggers
              ##
              # @return [ConvenientService::Support::UniqueValue]
              #
              STUB_ENTRY = Support::UniqueValue.new("STUB_ENTRY")
            end
          end
        end
      end
    end
  end
end
