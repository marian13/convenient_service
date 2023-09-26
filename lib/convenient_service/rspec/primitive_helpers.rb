# frozen_string_literal: true

require_relative "primitive_helpers/classes"

require_relative "primitive_helpers/ignoring_exception"
require_relative "primitive_helpers/in_threads"

module ConvenientService
  module RSpec
    module PrimitiveHelpers
      include Support::Concern

      included do
        include IgnoringException
        include InThreads
      end
    end
  end
end
