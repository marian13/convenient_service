# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Import
        def import(...)
          Custom::Import.new(...)
        end
      end
    end
  end
end
