# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "hash/assert_valid_keys"
require_relative "hash/except"
require_relative "hash/triple_equality_compare"

module ConvenientService
  module Utils
    module Hash
      class << self
        def assert_valid_keys(...)
          AssertValidKeys.call(...)
        end

        def except(...)
          Except.call(...)
        end

        def triple_equality_compare(...)
          TripleEqualityCompare.call(...)
        end
      end
    end
  end
end
