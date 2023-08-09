# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module IgnoringException
        def ignoring_exception(...)
          Custom::IgnoringException.call(...)
        end
      end
    end
  end
end
