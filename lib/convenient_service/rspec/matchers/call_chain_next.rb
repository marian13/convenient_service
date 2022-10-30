# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module CallChainNext
        def call_chain_next(...)
          Custom::CallChainNext.new(...)
        end
      end
    end
  end
end
