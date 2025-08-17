# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module CacheItsValue
        def cache_its_value(...)
          Classes::CacheItsValue.new(...)
        end
      end
    end
  end
end
