# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module IgnoringError
        def ignoring_error(*errors, &block)
          Custom::IgnoringError.call(*errors, &block)
        end
      end
    end
  end
end
