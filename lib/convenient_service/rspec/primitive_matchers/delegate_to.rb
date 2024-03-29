# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module DelegateTo
        def delegate_to(...)
          Classes::DelegateTo.new(...)
        end
      end
    end
  end
end
