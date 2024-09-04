# frozen_string_literal: true

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
