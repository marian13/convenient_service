# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  ##
  # Intermediate module to access `ConvenientService::Standard::Config` by the end-users.
  #
  # @api public
  # @since 1.0.0
  #
  module Standard
    ##
    # Convenient Service main entrypoint.
    #
    # @api public
    # @since 1.0.0
    # @example Allows to define services.
    #   class Service
    #     include ConvenientService::Standard::Config
    #
    #     def result
    #       success
    #     end
    #   end
    # @example Can be customized by `with`, `without`, `with_defaults`, `without_defaults` options.
    #   class Service
    #     include ConvenientService::Standard::Config
    #       .with(:fault_tolerance)
    #       .without(:short_syntax)
    #
    #     def result
    #       success
    #     end
    #   end
    # @note See `ConvenientService::Standard::Config.default_options` for default options.
    # @note See `ConvenientService::Standard::Config.available_options` for all available options.
    #
    Config = ::ConvenientService::Service::Configs::Standard
  end
end
