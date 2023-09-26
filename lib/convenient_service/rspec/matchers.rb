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
        include Matchers::CallChainNext
        include Matchers::DelegateTo
        include Matchers::Export
        include Matchers::IncludeModule
        include Matchers::Results
      end
    end
  end
end
