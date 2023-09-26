# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module BeDescendantOf
        def be_descendant_of(...)
          Classes::BeDescendantOf.new(...)
        end
      end
    end
  end
end
