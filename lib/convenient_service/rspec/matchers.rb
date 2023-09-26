# frozen_string_literal: true

require_relative "matchers/classes"

require_relative "matchers/call_chain_next"
require_relative "matchers/delegate_to"
require_relative "matchers/export"
require_relative "matchers/include_module"
require_relative "matchers/results"

module ConvenientService
  module RSpec
    module Matchers
      include Support::Concern

      included do
        include CallChainNext
        include DelegateTo
        include Export
        include IncludeModule
        include Results
      end
    end
  end
end
