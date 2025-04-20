# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "service/concern"

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          ##
          # @internal
          #   NOTE: Service is a wrapper for a service class (klass).
          #   For example:
          #
          #     step SomeService, in: :foo, out: :bar
          #     # klass is `SomeService` in this particular case.
          #
          class Service
            include Concern
          end
        end
      end
    end
  end
end
