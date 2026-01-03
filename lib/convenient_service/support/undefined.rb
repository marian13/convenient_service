# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    class Undefined < Support::UniqueValue; end

    ##
    # @return [ConvenientService::Support::UniqueValue]
    #
    UNDEFINED = Support::Undefined.new("undefined")
  end
end
