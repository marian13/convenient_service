# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module HaveAttrAccessor
        def have_attr_accessor(...)
          Classes::HaveAttrAccessor.new(...)
        end
      end
    end
  end
end
