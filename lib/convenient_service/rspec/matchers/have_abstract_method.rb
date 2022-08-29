# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module HaveAbstractMethod
        def have_abstract_method(*args)
          Custom::HaveAbstractMethod.new(*args)
        end
      end
    end
  end
end
