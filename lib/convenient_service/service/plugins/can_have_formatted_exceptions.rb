# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "can_have_formatted_exceptions/commands"
require_relative "can_have_formatted_exceptions/constants"

module ConvenientService
  module Service
    module Plugins
      module CanHaveFormattedExceptions
        class << self
          ##
          # @return [Integer]
          #
          def default_max_backtrace_size
            Constants::DEFAULT_MAX_BACKTRACE_SIZE
          end

          ##
          # @param exception [StandardError]
          # @param kwargs [Hash{Symbol => Object}]
          # @return [String]
          #
          def format_exception(exception, **kwargs)
            Commands::FormatException.call(exception: exception, **kwargs)
          end
        end
      end
    end
  end
end
