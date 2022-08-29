# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module HaveAttrAccessor
        def have_attr_accessor(*args)
          Custom::HaveAttrAccessor.new(*args)
        end
      end
    end
  end
end
