# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module PrependModule
        def prepend_module(...)
          Classes::PrependModule.new(...)
        end
      end
    end
  end
end
