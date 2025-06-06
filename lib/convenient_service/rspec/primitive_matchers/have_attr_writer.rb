# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module HaveAttrWriter
        def have_attr_writer(...)
          Classes::HaveAttrWriter.new(...)
        end
      end
    end
  end
end
