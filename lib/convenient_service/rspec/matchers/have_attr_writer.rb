# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module HaveAttrWriter
        def have_attr_writer(...)
          Custom::HaveAttrWriter.new(...)
        end
      end
    end
  end
end
