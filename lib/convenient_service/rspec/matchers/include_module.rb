# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module IncludeModule
        def include_module(...)
          RSpec::PrimitiveMatchers::Classes::IncludeModule.new(...)
        end
      end
    end
  end
end
