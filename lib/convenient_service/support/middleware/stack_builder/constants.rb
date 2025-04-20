# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module Middleware
      class StackBuilder
        module Constants
          module Backends
            ##
            # @return [Symbol]
            #
            RUBY_MIDDLEWARE = :ruby_middleware

            ##
            # @return [Symbol]
            #
            RACK = :rack

            ##
            # @return [Symbol]
            #
            STATEFUL = :stateful

            ##
            # @return [Array<Symbol>]
            #
            ALL = [RUBY_MIDDLEWARE, RACK, STATEFUL]

            ##
            # @return [Symbol]
            #
            DEFAULT = RUBY_MIDDLEWARE
          end
        end
      end
    end
  end
end
