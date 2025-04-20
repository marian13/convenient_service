# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "result/concern"
require_relative "result/plugins"

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            include Concern
          end
        end
      end
    end
  end
end
