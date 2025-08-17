# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "helpers/classes"

require_relative "helpers/ignoring_exception"
require_relative "helpers/in_threads"

require_relative "helpers/stub_service"
require_relative "helpers/stub_entry"
require_relative "helpers/wrap_method"

module ConvenientService
  module RSpec
    module Helpers
      include Support::Concern

      included do
        include InThreads

        include IgnoringException
        include StubService
        include StubEntry
        include WrapMethod
      end
    end
  end
end
