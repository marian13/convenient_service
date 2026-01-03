# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    class Block < Support::UniqueValue; end

    ##
    # @return [ConvenientService::Support::UniqueValue]
    #
    BLOCK = Support::Block.new("block")
  end
end
