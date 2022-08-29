# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module HaveAttrWriter
        def have_attr_writer(*args)
          Custom::HaveAttrWriter.new(*args)
        end
      end
    end
  end
end
