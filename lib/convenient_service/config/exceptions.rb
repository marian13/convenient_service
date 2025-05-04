# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Config
    module Exceptions
      class OptionCanNotBeNormalized < ::ConvenientService::Exception
        ##
        # @param option [Object] Can be any type.
        # @return [void]
        #
        def initialize_with_kwargs(option:)
          message = <<~TEXT
            Option `#{option.inspect}` can NOT be normalized.

            Consider passing `Symbol` or `Hash` instead.
          TEXT

          initialize(message)
        end
      end
    end
  end
end
