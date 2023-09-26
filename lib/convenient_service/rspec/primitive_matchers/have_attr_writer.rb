# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module HaveAttrWriter
        def have_attr_writer(...)
          Classes::HaveAttrWriter.new(...)
        end
      end
    end
  end
end
