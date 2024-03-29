# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module IgnoringException
        def ignoring_exception(...)
          RSpec::PrimitiveHelpers::Classes::IgnoringException.call(...)
        end
      end
    end
  end
end
