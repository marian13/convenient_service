# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module WrapMethod
        def wrap_method(*args, **kwargs)
          Custom::WrapMethod.call(*args, **kwargs)
        end
      end
    end
  end
end
