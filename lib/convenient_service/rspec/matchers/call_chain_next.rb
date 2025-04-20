# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module CallChainNext
        def call_chain_next(...)
          Classes::CallChainNext.new(...)
        end
      end
    end
  end
end
