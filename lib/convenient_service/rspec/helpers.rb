# frozen_string_literal: true

require_relative "helpers/custom"

require_relative "helpers/ignoring_error"
require_relative "helpers/in_threads"
require_relative "helpers/stub_service"
require_relative "helpers/wrap_method"

module ConvenientService
  module RSpec
    module Helpers
      include Support::Concern

      included do
        include Helpers::IgnoringError
        include Helpers::InThreads
        include Helpers::StubService
        include Helpers::WrapMethod
      end
    end
  end
end
