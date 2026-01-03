# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "null_arguments/exceptions"

module ConvenientService
  module Support
    class Arguments
      ##
      # @api private
      #
      class NullArguments < Support::Arguments
        ##
        # @return [void]
        #
        def initialize
          @args = [].freeze
          @kwargs = {}.freeze
          @block = nil
        end

        ##
        # @param other_block [Proc, nil]
        #
        def block=(other_block)
          ::ConvenientService.raise Exceptions::BlockSetIsNotAllowed.new
        end

        ##
        # @return [Boolean]
        #
        def null_arguments?
          true
        end

        ##
        # @return [Boolean]
        #
        alias_method :nil_arguments?, :null_arguments?

        ##
        # @return [ConvenientService::Support::Arguments]
        #
        def to_arguments
          ConvenientService::Support::Arguments.new
        end
      end
    end
  end
end
