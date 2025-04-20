# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "name/append"

module ConvenientService
  module Utils
    module Method
      module Name
        class << self
          def append(...)
            Append.call(...)
          end
        end
      end
    end
  end
end
