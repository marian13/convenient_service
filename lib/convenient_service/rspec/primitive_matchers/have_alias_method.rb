# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module HaveAliasMethod
        def have_alias_method(...)
          Classes::HaveAliasMethod.new(...)
        end
      end
    end
  end
end
