# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "method/defined"
require_relative "method/loose_call"
require_relative "method/name"
require_relative "method/remove"

module ConvenientService
  module Utils
    module Method
      class << self
        def defined?(...)
          Defined.call(...)
        end

        def loose_call(...)
          LooseCall.call(...)
        end

        def remove(...)
          Remove.call(...)
        end
      end
    end
  end
end
