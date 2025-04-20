# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Core
    module Constants
      module Commits
        ##
        # @return [Integer]
        #
        METHOD_MISSING_MAX_TRIES = 10
      end

      module Triggers
        ##
        # @return [ConvenientService::Support::UniqueValue]
        #
        CLASS_METHOD_MISSING = Support::UniqueValue.new("CLASS_METHOD_MISSING")

        ##
        # @return [ConvenientService::Support::UniqueValue]
        #
        INSTANCE_METHOD_MISSING = Support::UniqueValue.new("INSTANCE_METHOD_MISSING")

        ##
        # @return [ConvenientService::Support::UniqueValue]
        #
        RESOLVE_METHOD_MIDDLEWARES_SUPER_METHOD = Support::UniqueValue.new("RESOLVE_METHOD_MIDDLEWARES_SUPER_METHOD")

        ##
        # @return [ConvenientService::Support::UniqueValue]
        #
        USER = Support::UniqueValue.new("USER")
      end
    end
  end
end
