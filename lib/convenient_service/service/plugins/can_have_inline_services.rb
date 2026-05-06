# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "can_have_inline_services/concern"
require_relative "can_have_inline_services/entities"
require_relative "can_have_inline_services/exceptions"

# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveInlineServices
        class << self
          ##
          # @api private
          # @param block [Proc, nil]
          # @return [ConvenientService::Service::Plugins::CanHaveInlineServices::Entities::Proxy]
          #
          def proxy(&block)
            Entities::Proxy.new(&block)
          end
        end
      end
    end
  end
end
