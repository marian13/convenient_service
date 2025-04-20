# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module BeDirectDescendantOf
        def be_direct_descendant_of(...)
          Classes::BeDirectDescendantOf.new(...)
        end
      end
    end
  end
end
