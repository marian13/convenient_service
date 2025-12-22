# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "enumerable/find_last"

module ConvenientService
  module Utils
    module Enumerable
      class << self
        def find_last(...)
          FindLast.call(...)
        end
      end
    end
  end
end
