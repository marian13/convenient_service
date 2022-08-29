# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module DelegateTo
        def delegate_to(*args)
          Custom::DelegateTo.new(*args)
        end
      end
    end
  end
end
