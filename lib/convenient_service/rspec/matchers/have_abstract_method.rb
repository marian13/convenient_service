# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module HaveAbstractMethod
        def have_abstract_method(...)
          Custom::HaveAbstractMethod.new(...)
        end
      end
    end
  end
end
