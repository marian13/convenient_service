# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module HaveAbstractMethod
        def have_abstract_method(...)
          Classes::HaveAbstractMethod.new(...)
        end
      end
    end
  end
end
