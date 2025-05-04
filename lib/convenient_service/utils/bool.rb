# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "bool/to_bool"
require_relative "bool/to_env_bool"

module ConvenientService
  module Utils
    module Bool
      class << self
        def to_bool(...)
          ToBool.call(...)
        end

        def to_env_bool(...)
          ToEnvBool.call(...)
        end
      end
    end
  end
end
