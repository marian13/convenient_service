# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "can_have_stubbed_results/commands"
require_relative "can_have_stubbed_results/concern"
require_relative "can_have_stubbed_results/entities"
require_relative "can_have_stubbed_results/middleware"

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResults
        class << self
          def set_service_stubbed_result(service, arguments, result)
            Commands::SetServiceStubbedResult[service: service, arguments: arguments, result: result]
          end
        end
      end
    end
  end
end
