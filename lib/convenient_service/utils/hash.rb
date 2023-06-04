# frozen_string_literal: true

require_relative "hash/assert_valid_keys"
require_relative "hash/except"

module ConvenientService
  module Utils
    module Hash
      class << self
        def assert_valid_keys(...)
          AssertValidKeys.call(...)
        end

        def except(...)
          Except.call(...)
        end
      end
    end
  end
end
