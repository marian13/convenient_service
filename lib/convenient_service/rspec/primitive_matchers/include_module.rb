# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module IncludeModule
        def include_module(...)
          Classes::IncludeModule.new(...)
        end
      end
    end
  end
end
