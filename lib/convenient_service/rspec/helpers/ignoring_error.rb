# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module IgnoringError
        def ignoring_error(...)
          Custom::IgnoringError.call(...)
        end
      end
    end
  end
end
