# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module HaveAttrReader
        def have_attr_reader(...)
          Classes::HaveAttrReader.new(...)
        end
      end
    end
  end
end
