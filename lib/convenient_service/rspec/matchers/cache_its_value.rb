# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module CacheItsValue
        def cache_its_value(...)
          Classes::CacheItsValue.new(...)
        end
      end
    end
  end
end
