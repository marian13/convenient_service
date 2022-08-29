# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module BeDescendantOf
        def be_descendant_of(*args)
          Custom::BeDescendantOf.new(*args)
        end
      end
    end
  end
end
