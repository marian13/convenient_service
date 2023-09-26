# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveHelpers
      module IgnoringException
        def ignoring_exception(...)
          Classes::IgnoringException.call(...)
        end
      end
    end
  end
end
