# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module HaveAbstractMethod
        def have_abstract_method(...)
          Classes::HaveAbstractMethod.new(...)
        end
      end
    end
  end
end
