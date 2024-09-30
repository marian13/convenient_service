# frozen_string_literal: true

require_relative "helpers/classes"

require_relative "helpers/ignoring_exception"
require_relative "helpers/stub_service"
require_relative "helpers/stub_entry"
require_relative "helpers/wrap_method"

module ConvenientService
  module RSpec
    module Helpers
      include Support::Concern

      included do
        include IgnoringException
        include StubService
        include StubEntry
        include WrapMethod
      end
    end
  end
end
