# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module WrapMethod
        def wrap_method(...)
          Custom::WrapMethod.call(...)
        end
      end
    end
  end
end
