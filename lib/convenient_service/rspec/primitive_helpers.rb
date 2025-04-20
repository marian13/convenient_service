# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "primitive_helpers/classes"

require_relative "primitive_helpers/ignoring_exception"
require_relative "primitive_helpers/in_threads"

module ConvenientService
  module RSpec
    module PrimitiveHelpers
      include Support::Concern

      included do
        include IgnoringException
        include InThreads
      end
    end
  end
end
