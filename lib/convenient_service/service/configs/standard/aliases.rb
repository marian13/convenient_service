# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Standard
    ##
    # Intermediate module to access `ConvenientService::Standard::V1::Config` by the end-users.
    #
    # @api public
    # @since 1.0.0
    # @deprecated Refactor your code or use a backport.
    # @see https://userdocs.convenientservice.org/deprecations/jsend_meaning_of_failure_and_error
    #
    module V1
      ##
      # Deprecated Convenient Service main entrypoint.
      #
      # @api public
      # @since 1.0.0
      # @deprecated Refactor your code or use a backport.
      # @see https://userdocs.convenientservice.org/deprecations/jsend_meaning_of_failure_and_error
      # @example Allows to define services.
      #   class Service
      #     include ConvenientService::Standard::V1::Config
      #
      #     def result
      #       success
      #     end
      #   end
      #
      Config = ::ConvenientService::Service::Configs::Standard::V1
    end
  end
end
