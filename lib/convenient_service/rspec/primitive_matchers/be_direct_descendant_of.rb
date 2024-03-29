# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module BeDirectDescendantOf
        def be_direct_descendant_of(...)
          Classes::BeDirectDescendantOf.new(...)
        end
      end
    end
  end
end
