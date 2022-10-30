# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module HaveAttrReader
        def have_attr_reader(...)
          Custom::HaveAttrReader.new(...)
        end
      end
    end
  end
end
