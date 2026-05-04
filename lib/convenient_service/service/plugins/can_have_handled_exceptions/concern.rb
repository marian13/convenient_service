# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveHandledExceptions
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @api public
            # @param max_backtrace_size [Integer]
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def error_from_exception(exception, max_backtrace_size: Plugins::CanHaveFormattedExceptions.default_max_backtrace_size)
              error(
                data: {handled_exception: exception},
                message: Plugins::CanHaveFormattedExceptions.format_exception(exception, max_backtrace_size: max_backtrace_size),
                code: :handled_exception
              )
                .copy(overrides: {kwargs: {exceptions: {handled: exception}}})
            end
          end
        end
      end
    end
  end
end
